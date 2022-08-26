import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  AuthService({
    required this.firebaseAuth,
  });
  Stream<User?> get authState => firebaseAuth.authStateChanges();

  //Send email verification
  void sendEmailVerification() async {
    await firebaseAuth.currentUser!.sendEmailVerification();
  }

  //reset password
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  //Sign up
  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
    required model.User user,
  }) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    )
        .then((value) {
      user.id = value.user!.uid;
    });
    await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .createUser(user);
  }

  // sign in
  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  Future<void> logOut(BuildContext context) async {
    await firebaseAuth.signOut();
  }
}
