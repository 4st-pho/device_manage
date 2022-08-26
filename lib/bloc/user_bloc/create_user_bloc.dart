import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';

class CreateUserBloc {
  CreateUserBloc() {
    TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllTeam()
        .then((listTeam) => _listTeamController.sink.add(listTeam));
  }
  Team? team;
  final StreamController<List<Team>> _listTeamController =
      StreamController<List<Team>>();
  Stream<List<Team>> get streamListTeam => _listTeamController.stream;
  void chooseTeam(Team? team) {
    if (team != null) {
      this.team = team;
    }
  }

  void dispose() {
    _listTeamController.close();
  }
}
