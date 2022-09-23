import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/model/team.dart';

class TeamService {
  final teamCollection =
      FirebaseFirestore.instance.collection(AppCollectionPath.team);
  Future<void> createTeam(String name, {String? imagePath}) async {
    final teamDoc = teamCollection.doc();
    final team = Team(id: teamDoc.id, name: name.trim());
    team.id = teamDoc.id;
    await teamDoc.set(team.toMap());
  }

  Future<Team> getTeam(String teamId) async {
    final teamDoc = teamCollection.doc(teamId);
    final snapshot = await teamDoc.get();
    return Team.fromMap(snapshot.data()!);
  }

  Future<List<Team>> getAllTeam() async {
    final teamDoc = teamCollection;
    final snapshot = await teamDoc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => Team.fromMap(e.data())).toList();
  }

  Future<List<String>> getTeamIdByName(String name) async {
    final teamDoc = teamCollection
        .where('name', isEqualTo: name);
    final snapshot = await teamDoc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<String>> getAllTeamName() async {
    final teamDoc = teamCollection;
    final snapshot = await teamDoc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }
}