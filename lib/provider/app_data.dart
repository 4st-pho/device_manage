import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';

class AppData extends ChangeNotifier {
  model.User? _currentUser;
  model.User? get currentUser => _currentUser;
  Future<void> getCurrentUser() async {
    _currentUser = await UserService().getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }
}
