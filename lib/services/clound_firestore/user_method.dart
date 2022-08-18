// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';

import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class UserMethod {
  FirebaseFirestore firebaseFirestore;
  Future<void> createUser(BuildContext context, User user) async {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.user).doc(user.id);
      await doc.set(user.toMap());
      showSnackBar(context: context, content: 'Create user success!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  // get curent user in cloud firebaseFirestore

  Future<List<String>> getAllUserName() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }

  Future<User> getUser( String uid) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user).doc(uid);
    final snapshot = await doc.get();
    return User.fromMap(snapshot.data()!);
  }

  Future<List<String>> getUserIdByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<User>> getUserByName({required String name}) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }

  Future<List<User>> getAllUser() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => User.fromMap(e.data())).toList();
  }

  UserMethod({
    required this.firebaseFirestore,
  });
  Future<List<User>> getUserSameTeam() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('teamId', isEqualTo: currentUser!.teamId);
    final value = await doc.get();
    return value.docs.map((e) => User.fromMap(e.data())).toList();
  }

  Future<List<User>> getLeader() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.user)
        .where('teamId', isEqualTo: currentUser!.teamId)
        .where('role', isEqualTo: 'leader');
    final value = await doc.get();
    return value.docs.map((e) => User.fromMap(e.data())).toList();
  }
}
