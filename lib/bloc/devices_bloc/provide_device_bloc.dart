import 'dart:async';

import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/team_service.dart';
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ProvideDeviceBloc {
  List<OwnerType> listOwnerType = [OwnerType.user, OwnerType.team];

  /// loading when click button
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  //select user or team in dropdown button
  final _chooseOwnerTypeController =
      BehaviorSubject<OwnerType>.seeded(OwnerType.user);
  Stream<OwnerType> get chooseOwnerTypeStream =>
      _chooseOwnerTypeController.stream;

  /// choose user name in dropdown button
  final _chooseUserController = BehaviorSubject<User?>.seeded(null);
  Stream<User?> get userStream => _chooseUserController.stream;

  /// choose team name in dropdown button
  final _chooseTeamController = BehaviorSubject<Team?>.seeded(null);
  Stream<Team?> get teamStream => _chooseTeamController.stream;

  //get data from stream in BehaviorSbject
  OwnerType get ownerType => _chooseOwnerTypeController.value;
  User? get userData => _chooseUserController.value;
  Team? get teamData => _chooseTeamController.value;

  void setUser(User? user) {
    if (user != userData) {
      _chooseUserController.sink.add(user);
    }
  }

  void setTeam(Team team) {
    if (team != teamData) {
      _chooseTeamController.sink.add(team);
    }
  }

  void onOwnerTypeChange(OwnerType? ownerType) {
    if (ownerType != null) {
      _chooseOwnerTypeController.sink.add(ownerType);
    }
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<List<Team>> getAllTeam() {
    return TeamService().getAllTeam();
  }

  Future<List<User>> getAllUser() {
    return UserService().getAllUser();
  }

  Future<void> provideDevice(String deviceId) async {
    try {
      setLoadState(true);
      String ownerId = '';
      if (ownerType == OwnerType.user && userData == null) {
        throw AppString.userNotEmpty;
      }
      if (ownerType == OwnerType.team && teamData == null) {
        throw AppString.teamNotEmpty;
      }
      if (ownerType == OwnerType.user) {
        ownerId = userData!.id;
      } else {
        ownerId = teamData!.id;
      }
      await DeviceService()
          .provideDevice(id: deviceId, ownerId: ownerId, ownerType: ownerType);
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _chooseOwnerTypeController.close();
    _loadController.close();
    _chooseTeamController.close();
    _chooseUserController.close();
  }
}
