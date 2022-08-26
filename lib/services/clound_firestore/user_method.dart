import 'package:manage_devices_app/enums/role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';

import 'package:manage_devices_app/model/user.dart';

class UserMethod {
  FirebaseFirestore firebaseFirestore;
  UserMethod({
    required this.firebaseFirestore,
  });
  Future<void> createUser(User user) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.user).doc(user.id);
    await doc.set(user.toMap());
  }

  // get curent user in cloud firebaseFirestore

  Future<List<String>> getAllUserName() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }

  Future<List<String>> getAllUserIdSameTeam(String teamId) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user);
    final snapshot = await doc.where('teamId', isEqualTo: teamId).get();
    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<User> getUser(String uid) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user).doc(uid);
    final snapshot = await doc.get();

    return User.fromMap(snapshot.data()!);
  }

  Future<List<String>> getUserIdByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<User>> getUserByName({required String name}) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }

  Future<List<User>> getAllUser() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }

  Future<List<User>> getUserSameTeam(String teamId) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('teamId', isEqualTo: teamId);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }

  Future<List<User>> getLeader(String teamId) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('teamId', isEqualTo: teamId)
        .where('role', isEqualTo: Role.leader.name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }
}
