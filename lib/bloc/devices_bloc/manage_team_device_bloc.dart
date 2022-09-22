import 'dart:async';

import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/team_service.dart';

class ManageTeamDeviceBloc {
  /// search by _keywork
  String _keywork = '';

  /// init _listDeviceSubcription for cancel listen stream when dispose
  late final StreamSubscription _listDeviceSubcription;
  ManageTeamDeviceBloc() {
    _listDeviceSubcription = DeviceService().streamAlltDevice().listen((_) {
      updateListDeviceData();
    });
  }

  void setSearchKeywork(String keywork) => _keywork = keywork;
  
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
    List<Device> listDeviceData = await searchTeamDevice();
    _listDeviceController.sink.add(listDeviceData);
  }

  Future<List<Device>> searchTeamDevice() async {
    if (_keywork.isEmpty) {
      return DeviceService().getAllTeamDevice();
    }
    List<Team> allTeam = await TeamService().getAllTeam();
    final filterTeam = allTeam
        .where((team) => team.name.trim().toLowerCase().contains(_keywork))
        .toList();
    final teamIds = filterTeam.map((e) => e.id).toList();

    List<Device> searchResult = [];
    List<Device> tempListDevice = [];
    for (var e in teamIds) {
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
