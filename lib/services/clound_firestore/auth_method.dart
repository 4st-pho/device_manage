// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';

class AuthMethod {
  final FirebaseFirestore firebaseFirestore;
  AuthMethod({
    required this.firebaseFirestore,
  });


  Future updateUserProfile(
      {required String name,
      required File? file,
      required BuildContext context,
      required String avataLink}) async {
    String avatar = file == null
        ? avataLink
        : await StorageMethods(firebaseStorage: FirebaseStorage.instance)
            .uploadAndGetImageLink(AppCollectionPath.user, file);
    final docUser = firebaseFirestore
        .collection(AppCollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      await docUser.update({'name': name.trim(), 'avatar': avatar});
      showSnackBar(
          context: context, content: 'Update successfully!', title: 'Update');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), title: 'Error');
    }
  }
}
