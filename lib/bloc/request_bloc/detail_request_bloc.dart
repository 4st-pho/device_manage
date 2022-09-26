import 'dart:async';

import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';
import 'package:rxdart/rxdart.dart';

class DetailRequestBloc {
  /// init _updateRealtimeRequestStatus for cancel listen stream when dispose
  late final StreamSubscription<Request> _updateRealtimeRequestStatus;

  void setRealtimeRequestStatus(String requestID) {
    _updateRealtimeRequestStatus =
        RequestService().streamRequest(requestID).listen((event) {
      _requestStatusController.add(event.requestStatus);
    });
  }

  ///  update when properties  requestStatus of request change
  final _requestStatusController = StreamController<RequestStatus>();
  Stream<RequestStatus> get requestStatusStream =>
      _requestStatusController.stream;

  /// set loading when click button handle data
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
    try {
      setLoadState(true);
      RequestService().updateRequestStatus(id, requestStatus);
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  Future<void> acceptRequest(Request request) async {
    try {
      setLoadState(true);
      await RequestService()
          .updateRequestStatus(request.id, RequestStatus.accept);
      if (request.errorType == ErrorType.noError) {
        await DeviceService().provideDevice(
          id: request.deviceId,
          ownerId: request.ownerId,
          ownerType: request.ownerType,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _requestStatusController.close();
    _updateRealtimeRequestStatus.cancel();
  }
}
