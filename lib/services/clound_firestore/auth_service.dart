// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  AuthService({
    required this.firebaseAuth,
  });
  Stream<User?> get authState => firebaseAuth.authStateChanges();

  //Send email verification
  void sendEmailVerification({
    required BuildContext context,
  }) async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
      showSnackBar(context: context, content: 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!, error: true);
    }
  }

  //reset password
  Future<void> resetPassword(
      {required BuildContext context, required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
      showSnackBar(
          context: context,
          content: 'Instructions for resetting the password have been sent!');

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!, error: true);
      Navigator.of(context).pop();
    }
  }

  //Sign up
  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
    required model.User user,
    required BuildContext context,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      user.id = FirebaseAuth.instance.currentUser!.uid;
      // ignore: use_build_context_synchronously
      await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
          .createUser(context, user);
      showSnackBar(
          context: context, content: 'Sign up success!', title: 'Sign up');
      await Future.delayed(const Duration(milliseconds: 500));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!, error: true);
    }
  }

  // sign in
  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
          // ignore: use_build_context_synchronously
          // Navigator.of(context).pushReplacementNamed(Routes.initRoute);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!, error: true);
    }
  }

  Future<void> logOut({required BuildContext context}) async {
    try {
      await firebaseAuth.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed(Routes.loginRoute);
      showSnackBar(
        context: context,
        content: 'Log out',
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!, error: true);
    }
  }
}
