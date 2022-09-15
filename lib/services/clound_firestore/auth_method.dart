import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';

class AuthMethod {
  final FirebaseFirestore firebaseFirestore;
  AuthMethod({
    required this.firebaseFirestore,
  });

  Future updateUserProfile(
      {required String name,
      required File? file,
      required String avataLink}) async {
    String avatar = file == null
        ? avataLink
        : await StorageService()
            .uploadAndGetImageLink(AppCollectionPath.user, file);
    final docUser = firebaseFirestore
        .collection(AppCollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await docUser.update({'name': name.trim(), 'avatar': avatar});
  }
}
