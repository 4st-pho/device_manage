import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/search_filter.dart';
import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';

class SearchBloc {
  Team? team;
  User? user;
  String keywork = '';
  List<SearchFilter> searchFilter = [];
  List<Device> allDevice = [];
  List<Device> currentDevices = [];
  final StreamController<List<Device>> _controller =
      StreamController<List<Device>>();

  Stream<List<Device>> get stream => _controller.stream;
  final StreamController<List<SearchFilter>> _filterController =
      StreamController<List<SearchFilter>>.broadcast();

  Stream<List<SearchFilter>> get filterStream => _filterController.stream;

  final StreamController<dynamic> _userController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get userStream => _userController.stream;
  final StreamController<dynamic> _teamController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get teamStream => _teamController.stream;
  Future<void> getAlldevice() async {
    allDevice =
        await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllDevice();
  }

  SearchBloc() {
    getAlldevice().then((_) {
      init();
    });
  }
  void searchAvailableDevice() {
    currentDevices =
        allDevice.where((e) => e.ownerType == OwnerType.none).toList();
    currentDevices = currentDevices
        .where(
            (e) => e.name.toLowerCase().contains(keywork.trim().toLowerCase()))
        .toList();
  }

  void searchTeamDevices() {
    currentDevices =
        allDevice.where((e) => e.ownerType == OwnerType.team).toList();
    if (team != null) {
      currentDevices =
          currentDevices.where((e) => e.ownerId == team!.id).toList();
    }
    currentDevices = currentDevices
        .where(
            (e) => e.name.toLowerCase().contains(keywork.trim().toLowerCase()))
        .toList();
  }

  void searchUserDevices() {
    currentDevices =
        allDevice.where((e) => e.ownerType == OwnerType.user).toList();
    if (user != null) {
      currentDevices =
          currentDevices.where((e) => e.ownerId == user!.id).toList();
    }
    currentDevices = currentDevices
        .where(
            (e) => e.name.toLowerCase().contains(keywork.trim().toLowerCase()))
        .toList();
  }

  void init() {
    if (searchFilter.contains(SearchFilter.avalbleDevice)) {
      searchAvailableDevice();
    } else if (searchFilter.contains(SearchFilter.team)) {
      searchTeamDevices();
    } else if (searchFilter.contains(SearchFilter.user)) {
      searchUserDevices();
    } else {
      searchDevice();
    }
    sinkDevices();
  }

  void onTextChange(String? query) {
    keywork = query!.trim();
    Debounce().run(() {
      init();
    });
  }

  void searchDevice() {
    currentDevices = allDevice
        .where(
            (e) => e.name.toLowerCase().contains(keywork.trim().toLowerCase()))
        .toList();
  }

  void avalbleDeviceFilter(bool value) {
    if (value) {
      searchFilter = [SearchFilter.avalbleDevice];
    } else {
      searchFilter = [];
    }
    _filterController.sink.add(searchFilter);
    init();
  }

  void teamFilter(bool value) {
    if (value) {
      searchFilter = [SearchFilter.team];
    } else {
      searchFilter = [];
    }
    _filterController.sink.add(searchFilter);
    init();
  }

  void userFilter(bool value) {
    if (value) {
      searchFilter = [SearchFilter.user];
    } else {
      searchFilter = [];
    }
    _filterController.sink.add(searchFilter);
    init();
  }

  void onChooseUser(dynamic userParam) {
    user = userParam as User;
    _userController.sink.add(user);
    init();
  }

  void onClearUser() {
    user = null;
    _userController.sink.add(user);
    init();
  }

  void onClearTeam() {
    team = null;
    _teamController.sink.add(null);
    init();
  }

  void onSubmitted(BuildContext context,TextEditingController controller, {String? query}) {
    if (query != null) {
      keywork = query.trim();
      controller.text = keywork;
    }
    init();
    Navigator.of(context).pushNamed(Routes.searchResultRoute,
        arguments: [keywork, currentDevices]);
  }

  void onChooseTeam(dynamic teamParam) {
    team = teamParam as Team;
    _teamController.sink.add(team);
    init();
  }

  void sinkDevices() {
    _controller.sink.add(currentDevices);
  }

  void sinkSearchFilter() {
    _filterController.sink.add(searchFilter);
  }

  void sinkUserAndTeam() {
    _userController.sink.add(user);
    _teamController.sink.add(team);
  }

  void dispose() {
    _controller.close();
    _userController.close();
    _teamController.close();
    _filterController.close();
  }
}
