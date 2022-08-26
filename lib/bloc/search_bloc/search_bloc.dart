import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/search_filter.dart';
import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';

class SearchBloc {
  Team? _team;
  User? _user;
  String _keywork = '';
  List<SearchFilter> _searchFilter = [];
  List<Device> allDevice = [];
  List<Device> _currentDevices = [];
  final StreamController<List<Device>> _currentDevicesController =
      StreamController<List<Device>>();

  final StreamController<List<SearchFilter>> _filterController =
      StreamController<List<SearchFilter>>.broadcast();
  final StreamController<String?> _userController =
      StreamController<String?>.broadcast();
  final StreamController<String?> _teamController =
      StreamController<String?>.broadcast();

  Stream<List<Device>> get currentDevicesStream =>
      _currentDevicesController.stream;

  Stream<List<SearchFilter>> get filterStream => _filterController.stream;

  Stream<String?> get userStream => _userController.stream;

  Stream<String?> get teamStream => _teamController.stream;
  String get keywork => _keywork;
  List<Device> get currentDevices => _currentDevices;
  List<SearchFilter> get searchFilter => _searchFilter;
  Future<void> getAndSetAlldevice() async {
    allDevice =
        await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllDevice();
  }

  SearchBloc() {
    Future.wait([
      getAndSetAlldevice(),
    ]).then((value) {
      searchAction();
    });
  }

  void searchAction() {
    if (_searchFilter.contains(SearchFilter.avalbleDevice)) {
      _currentDevices = searchAvailableDevice();
    } else if (_searchFilter.contains(SearchFilter.team)) {
      _currentDevices = searchTeamDevices();
    } else if (_searchFilter.contains(SearchFilter.user)) {
      _currentDevices = searchUserDevices();
    } else {
      _currentDevices = searchDevice();
    }
    _currentDevicesController.sink.add(currentDevices);
  }

  List<Device> searchAvailableDevice() {
    List<Device> listCurrentDevices =
        allDevice.where((e) => e.ownerType == OwnerType.none).toList();
    listCurrentDevices = listCurrentDevices
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
    return listCurrentDevices;
  }

  List<Device> searchTeamDevices() {
    List<Device> listTeamDevice =
        allDevice.where((e) => e.ownerType == OwnerType.team).toList();
    if (_team != null) {
      listTeamDevice =
          listTeamDevice.where((e) => e.ownerId == _team!.id).toList();
    }
    listTeamDevice = listTeamDevice
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
    return listTeamDevice;
  }

  List<Device> searchUserDevices() {
    List<Device> listUserDevice =
        allDevice.where((e) => e.ownerType == OwnerType.user).toList();
    if (_user != null) {
      listUserDevice =
          listUserDevice.where((e) => e.ownerId == _user!.id).toList();
    }
    listUserDevice = listUserDevice
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
    return listUserDevice;
  }

  void onTextChange(String? query) {
    _keywork = query!.trim();
    Debounce().run(() {
      searchAction();
    });
  }

  List<Device> searchDevice() {
    return allDevice
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
  }

  void avalbleDeviceFilter(bool value) {
    if (value) {
      _searchFilter = [SearchFilter.avalbleDevice];
    } else {
      _searchFilter = [];
    }
    _filterController.sink.add(_searchFilter);
    searchAction();
  }

  void teamFilter(bool value) {
    if (value) {
      _searchFilter = [SearchFilter.team];
    } else {
      _searchFilter = [];
    }
    _filterController.sink.add(_searchFilter);
    searchAction();
  }

  void userFilter(bool value) {
    if (value) {
      _searchFilter = [SearchFilter.user];
    } else {
      _searchFilter = [];
    }
    _filterController.sink.add(_searchFilter);
    searchAction();
  }

  void onChooseUser(User user) {
    _user = user;
    _userController.sink.add(user.name);
    searchAction();
  }

  void onClearUser() {
    _user = null;
    _userController.sink.add(_user?.name);
    searchAction();
  }

  void onClearTeam() {
    _team = null;
    _teamController.sink.add(null);
    searchAction();
  }

  void onSubmitted(TextEditingController controller, {String? query}) {
    if (query != null) {
      _keywork = query.trim();
      controller.text = _keywork;
    }
    searchAction();
  }

  void onChooseTeam(Team team) {
    _team = team;
    _teamController.sink.add(team.name);
    searchAction();
  }

  void sinkSearchFilter() {
    _filterController.sink.add(_searchFilter);
  }

  void sinkUser() {
    _userController.sink.add(_user?.name);
  }

  void sinkTeam() {
    _teamController.sink.add(_team?.name);
  }

  void dispose() {
    _currentDevicesController.close();
    _userController.close();
    _teamController.close();
    _filterController.close();
  }
}
