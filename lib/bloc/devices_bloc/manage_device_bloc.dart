import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class ManageDeviceBloc {
  String keywork = '';
  int currenTab = 0;
  List<Device> devices = [];
  List<Device> listDevice = [];
  List<String> userIds = [];
  List<String> teamiIds = [];
  List<User> allUser = [];
  List<User> filterUser = [];
  List<Team> allTeam = [];
  List<Device> allDevice = [];
  List<Team> filterTeam = [];

  final StreamController<List<Device>> _controller =
      StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get stream => _controller.stream;

  void sinkDevices(List<Device> value) {
    _controller.sink.add(value);
  }

  ManageDeviceBloc() {
    getData();
    init();
  }
  Future<void> getData() async {
    allUser = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllUser();
    allTeam = await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllTeam();
  }

  void init() {
    devices = [];
    switch (currenTab) {
      case 0:
        searchUserDevice().then((value) {
          sinkDevices(devices);
        });
        break;
      case 1:
        searchTeamDevice().then((value) {
          sinkDevices(devices);
        });
        break;
      default:
        searchDevice();
        sinkDevices(devices);
    }
  }

  void onTextChange(String value) {
    keywork = value.trim().toLowerCase();
    Debounce().run(
      () {
        init();
      },
    );
  }

  void onTabChange(int index) {
    currenTab = index;
    init();
  }

  Future<void> recallDevice(BuildContext context, String id) async {
    await DeviceService().recallDevice(id);
    init();
  }

  Future<void> searchUserDevice() async {
    if (keywork.isEmpty) {
      devices = await DeviceService().getAllUserDevice();
      return;
    }
    filterUser = allUser
        .where((user) => user.name.trim().toLowerCase().contains(keywork))
        .toList();
    userIds = filterUser.map((e) => e.id).toList();
    for (var e in userIds) {
      listDevice = await DeviceService().getOwnerDevices(e);
      devices = [...devices, ...listDevice];
    }
  }

  Future<void> searchTeamDevice() async {
    if (keywork.isEmpty) {
      devices = await DeviceService().getAllTeamDevice();
      return;
    }
    filterTeam = allTeam
        .where((team) => team.name.trim().toLowerCase().contains(keywork))
        .toList();
    teamiIds = filterTeam.map((e) => e.id).toList();
    for (var e in teamiIds) {
      final device = await DeviceService().getOwnerDevices(e);
      devices = [...devices, ...device];
    }
  }

  Future<void> searchDevice() async {
    if (keywork.trim().isEmpty) {
      devices = await DeviceService().getAvailableDevice();
      return;
    }
    devices = await DeviceService().getAllDevice();
    devices = devices.where((e) => e.ownerId.isEmpty).toList();
    devices = devices
        .where((team) => team.name.trim().toLowerCase().contains(keywork))
        .toList();
  }

  void dispose() {
    _controller.close();
  }
}
