import 'dart:async';

import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:rxdart/rxdart.dart';

class DetailRequestBloc {
  late final  StreamSubscription<Request> _updateRealtimeRequestStatus;
  void setRealtimeRequestStatus(String requestID) {
    _updateRealtimeRequestStatus = RequestService().streamRequest(requestID).listen((event) {
      _requestStatusController.add(event.requestStatus);
    });
  }

  final _requestStatusController = StreamController<RequestStatus>();
  Stream<RequestStatus> get requestStatusStream =>
      _requestStatusController.stream;

  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  bool get isLoading => _loadController.value;

  void toggleState() {
    _loadController.add(!isLoading);
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<Device> getDevice(String id) {
    return DeviceService().getDevice(id);
  }

  Future<void> updateRequestStatus(
      String id, RequestStatus requestStatus) async {
    setLoadState(true);
    await RequestService()
        .updateRequestStatus(id, requestStatus)
        .catchError((error) {
      setLoadState(false);
      throw error;
    });
  }

  Future<void> acceptRequest({
    required String requestId,
    required RequestStatus requestStatus,
    required String deviceId,
    required ErrorStatus errorStatus,
    required String ownerId,
    required OwnerType ownerType,
  }) async {
    setLoadState(true);
    await RequestService()
        .updateRequestStatus(requestId, requestStatus)
        .catchError((error) {
      setLoadState(false);
      throw error;
    });
    if (errorStatus == ErrorStatus.noError) {
      await DeviceService()
          .provideDevice(
        id: deviceId,
        ownerId: ownerId,
        ownerType: ownerType,
      )
          .catchError((error) {
        setLoadState(false);
        throw error;
      });
    }
  }

  void dispose() {
    _requestStatusController.close();
    _updateRealtimeRequestStatus.cancel();
  }
}
