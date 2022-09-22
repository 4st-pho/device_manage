import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/search_filter.dart';
import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  /// init _deviceStreamSubscription for cancel listen  list realtime change when close when dispose page
  late final StreamSubscription _deviceStreamSubscription;

  /// search keywoork
  String _keywork = '';

  List<Device> _allDevice = [];
  List<Device> _seachDevicesResult = [];

  /// show device when search
  final _searchDevicesResultController = StreamController<List<Device>>();
  Stream<List<Device>> get searchDevicesResultStream =>
      _searchDevicesResultController.stream;

  /// filter device by switch adapter and active adapter is select (available device, team device, user device)
  /// switch filter switch adapter (only has value or null  ) if null search by all device else search by switch adapter filter device
  final _filterSwitchAdapterController =
      BehaviorSubject<SearchFilter?>.seeded(null);
  Stream<SearchFilter?> get filterSwitchAdapterStream =>
      _filterSwitchAdapterController.stream;

  /// choose user
  final _userController = BehaviorSubject<User?>.seeded(null);
  Stream<User?> get userStream => _userController.stream;

  /// choose team
  final _teamController = BehaviorSubject<Team?>.seeded(null);
  Stream<Team?> get teamStream => _teamController.stream;

  String get keywork => _keywork;
  List<Device> get seachDevicesResult => _seachDevicesResult;

  /// get data from behavierSubject
  User? get _user => _userController.value;
  Team? get _team => _teamController.value;
  SearchFilter? get searchFilterz => _filterSwitchAdapterController.value;
  Future<void> getAndSetAlldevice() async {
    _allDevice = await DeviceService().getAllDevice();
  }

  SearchBloc() {
    _deviceStreamSubscription =
        DeviceService().streamAlltDevice().listen((devices) {
      _allDevice = devices;
      updateSearchResult();
    });
    Future.wait([
      getAndSetAlldevice().then((_) {
        updateSearchResult();
      })
    ]);
  }
  Future<List<User>> getAllUser() =>
      UserMethod(firebaseFirestore: FirebaseFirestore.instance).getAllUser();
  Future<List<Team>> getAllTeam() =>
      TeamMethod(firebaseFirestore: FirebaseFirestore.instance).getAllTeam();

  void updateSearchResult() {
    if (searchFilterz == null) {
      _seachDevicesResult = searchDevice();
    } else {
      switch (searchFilterz) {
        case SearchFilter.avalbleDevice:
          _seachDevicesResult = searchAvailableDevice();
          break;
        case SearchFilter.teamDevice:
          _seachDevicesResult = searchTeamDevices();
          break;
        case SearchFilter.userDevice:
          _seachDevicesResult = searchUserDevices();
          break;
        default:
      }
    }
    _searchDevicesResultController.sink.add(_seachDevicesResult);
  }

  List<Device> searchAvailableDevice() {
    List<Device> listCurrentDevices =
        _allDevice.where((e) => e.ownerType == OwnerType.none).toList();
    listCurrentDevices = listCurrentDevices
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
    return listCurrentDevices;
  }

  List<Device> searchTeamDevices() {
    List<Device> listTeamDevice =
        _allDevice.where((e) => e.ownerType == OwnerType.team).toList();
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
        _allDevice.where((e) => e.ownerType == OwnerType.user).toList();
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

  void onSearch(String? query) {
    _keywork = query!.trim();
    Debounce().run(() {
      updateSearchResult();
    });
  }

  List<Device> searchDevice() {
    return _allDevice
        .where(
            (e) => e.name.toLowerCase().contains(_keywork.trim().toLowerCase()))
        .toList();
  }

  void avalbleDeviceFilter(bool value) {
    if (value) {
      _filterSwitchAdapterController.sink.add(SearchFilter.avalbleDevice);
    } else {
      _filterSwitchAdapterController.sink.add(null);
    }
    updateSearchResult();
  }

  void teamFilter(bool value) {
    if (value) {
      _filterSwitchAdapterController.sink.add(SearchFilter.teamDevice);
    } else {
      _filterSwitchAdapterController.sink.add(null);
    }
    updateSearchResult();
  }

  void userFilter(bool value) {
    if (value) {
      _filterSwitchAdapterController.sink.add(SearchFilter.userDevice);
    } else {
      _filterSwitchAdapterController.sink.add(null);
    }
    updateSearchResult();
  }

  void chooseUser(User user) {
    _userController.sink.add(user);
    updateSearchResult();
  }

  void clearUser() {
    _userController.sink.add(null);
    updateSearchResult();
  }

  void clearTeam() {
    _teamController.sink.add(null);
    updateSearchResult();
  }

  void submitted({String? query}) {
    if (query != null) {
      _keywork = query.trim();
    }
    updateSearchResult();
  }

  void onChooseTeam(Team team) {
    _teamController.sink.add(team);
    updateSearchResult();
  }

  void dispose() {
    _searchDevicesResultController.close();
    _userController.close();
    _teamController.close();
    _filterSwitchAdapterController.close();
    _deviceStreamSubscription.cancel();
  }
}
