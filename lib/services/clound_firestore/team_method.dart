import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/model/team.dart';

class TeamMethod {
  final FirebaseFirestore firebaseFirestore;
  TeamMethod({
    required this.firebaseFirestore,
  });
  Future<void> createTeam(String name, {String? imagePath}) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.team).doc();
    final team = Team(id: doc.id, name: name.trim());
    team.id = doc.id;
    await doc.set(team.toMap());
  }

  Future<Team> getTeam(String teamId) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.team).doc(teamId);
    final snapshot = await doc.get();
    return Team.fromMap(snapshot.data()!);
  }

  Future<List<Team>> getAllTeam() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.team);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => Team.fromMap(e.data())).toList();
  }

  Future<List<String>> getTeamIdByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<String>> getAllTeamName() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.team);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }
}
