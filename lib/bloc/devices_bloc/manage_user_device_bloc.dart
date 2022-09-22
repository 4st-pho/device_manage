import 'dart:async';

import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';

class ManageUserDeviceBloc {
  /// search by _keywork
  String _keywork = '';

  /// init _listDeviceSubcription for cancel listen stream when dispose
  late final StreamSubscription _listDeviceSubcription;
  ManageUserDeviceBloc() {
    _listDeviceSubcription = DeviceService().streamAlltDevice().listen((_) {
      updateListDeviceData();
    });
  }

  void setSearchKeywork(String  keywork) => _keywork = keywork;

  void onSearch(String keywork) {
    _keywork = keywork.trim();
    Debounce().run(
      () async {
        updateListDeviceData();
      },
    );
  }

  /// stream list device dependent of current tab or search keywork
  final _listDeviceController = StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get listDeviceStream => _listDeviceController.stream;

  Future<void> updateListDeviceData() async {
    List<Device> listDeviceData = await searchUserDevice();
    _listDeviceController.sink.add(listDeviceData);
  }

  Future<List<Device>> searchUserDevice() async {
    if (_keywork.trim().isEmpty) {
      return DeviceService().getAllUserDevice();
    }
    List<User> allUser = await UserService().getAllUser();
    final filterUser = allUser
        .where((user) => user.name.trim().toLowerCase().contains(_keywork))
        .toList();
    final userIds = filterUser.map((e) => e.id).toList();
    List<Device> searchResult = [];
    List<Device> tempListDevice = [];
    for (var e in userIds) {
      tempListDevice = await DeviceService().getOwnerDevices(e);
      searchResult.addAll(tempListDevice);
    }
    return searchResult;
  }

  void dispose() {
    _listDeviceSubcription.cancel();
    _listDeviceController.close();
  }
}
