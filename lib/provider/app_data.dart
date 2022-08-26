import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class AppData extends ChangeNotifier {
  model.User? currentUser;
  Future<void> getCurrentUser() async {
    currentUser =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance).getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }
}
