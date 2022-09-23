import 'dart:async';

import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';
import 'package:rxdart/rxdart.dart';

class DetailDeviceBloc {
  late final StreamSubscription<Device> _updateRealtimeDevice;

  void setRealtimeDevice(String deviceId) {
    _updateRealtimeDevice =
        DeviceService().streamDevice(deviceId).listen((device) {
      _deviceController.add(device);
    })
          ..onError(
            /// when device has deleted by another admin, the page will be keep stable and not throw error
            (_) {
              _updateRealtimeDevice.cancel();
            },
          );
  }

  /// stream device
  final _deviceController = StreamController<Device>();
  Stream<Device> get deviceStream => _deviceController.stream;

  /// set loading when click button handle data
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<void> recallDevice(String id) async {
    try {
      setLoadState(true);
      await DeviceService().recallDevice(id);
    } catch (error) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      setLoadState(true);
      _updateRealtimeDevice.cancel();
      await RequestService().deleteRequestsForDevice(deviceId);
      await DeviceService().deleteDevice(deviceId);
    } catch (error) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _deviceController.close();
    _updateRealtimeDevice.cancel();
  }
}
