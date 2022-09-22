import 'dart:async';

import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';

class ManageAvailableDeviceBloc {
  String _keywork = '';

  /// init _listDeviceSubcription for cancel listen stream when dispose
  late final StreamSubscription _listDeviceSubcription;
  ManageAvailableDeviceBloc() {
    _listDeviceSubcription = DeviceService().streamAlltDevice().listen((_) {
      updateListDeviceData();
    });
  }

  void setSearchKeywork(String keywork) => _keywork = keywork;

  /// stream list device dependent for UserDevice tab and search keywork
  final _listDeviceController = StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get listDeviceStream => _listDeviceController.stream;

  void onSearch(String keywork) {
    _keywork = keywork.trim();
    Debounce().run(
      () async {
        updateListDeviceData();
      },
    );
  }

  Future<void> updateListDeviceData() async {
    List<Device> listDeviceData = await searchAvaivableDevice();
    _listDeviceController.sink.add(listDeviceData);
  }

  Future<List<Device>> searchAvaivableDevice() async {
    if (_keywork.isEmpty) {
      return DeviceService().getAvailableDevice();
    }
    List<Device> availableDevice = await DeviceService().getAvailableDevice();
    return availableDevice
        .where((device) =>
            device.name.trim().toLowerCase().contains(_keywork.trim()))
        .toList();
  }

  void dispose() {
    _listDeviceSubcription.cancel();
    _listDeviceController.close();
  }
}
