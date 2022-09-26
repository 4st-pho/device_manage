import 'package:firebase_auth/firebase_auth.dart';

import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
    await UserService().createUser(user);
  }

  // sign in
  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
