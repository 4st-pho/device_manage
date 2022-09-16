import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class SearchResultBloc {
  late final String keywork;
  List<Device> devices = [];
  List<String> userIds = [];
  List<String> teamiIds = [];
  List<Device> listDevice = [];
  SearchResultBloc(this.keywork) {
    init();
  }
  Future<void> init() async {
    await DeviceService().getDeviceByName(keywork).then((value) {
      devices = [...devices, ...value];
    });
    userIds = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getUserIdByName(keywork);
    // ignore: avoid_function_literals_in_foreach_calls
    userIds.forEach((e) async {
      await DeviceService().getOwnerDevices(e).then((value) {
        devices = [...devices, ...value];
      });
    });
    teamiIds = await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getTeamIdByName(keywork);
    // ignore: avoid_function_literals_in_foreach_calls
    teamiIds.forEach((e) async {
      await DeviceService().getOwnerDevices(e).then((value) {
        devices = [...devices, ...value];
      });
    });
    sinkDevices(devices);
  }

  void updateByDevice() {
    listDevice = devices.where((e) => e.name == keywork).toList();
    sinkDevices(listDevice);
  }

  void updateByUser() {
    listDevice = devices.where((e) => userIds.contains(e.ownerId)).toList();
    sinkDevices(listDevice);
  }

  void updateByAvailableDevice() {
    listDevice = devices.where((e) => e.ownerId.isEmpty).toList();
    sinkDevices(listDevice);
  }

  void updateByTeam() {
    listDevice = devices.where((e) => teamiIds.contains(e.ownerId)).toList();
    sinkDevices(listDevice);
  }

  final StreamController<List<Device>> _controller =
      StreamController<List<Device>>();
  Stream<List<Device>> get stream => _controller.stream;
  final StreamController<int> _controllerChoiceChip = StreamController<int>();
  void sinkDevices(List<Device> value) {
    _controller.sink.add(value);
  }

  void selectedChoiceChip(int index) {
    _controllerChoiceChip.sink.add(index);
    switch (index) {
      case 1:
        updateByDevice();
        break;
      case 2:
        updateByUser();
        break;
      case 3:
        updateByTeam();
        break;
      case 4:
        updateByAvailableDevice();
        break;
      default:
        sinkDevices(devices);
    }
  }

  Stream<int> get streamChoiceChip => _controllerChoiceChip.stream;

  void dispose() {
    _controller.close();
  }
}
