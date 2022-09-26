import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  /// loading when click login button
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  /// option for show hide password
  final _showPasswordController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get showPasswordStream => _showPasswordController.stream;

  void toggleShowPasswordState() {
    _showPasswordController.sink.add(!_showPasswordController.value);
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<void> login(String email, String password) async {
    try {
      setLoadState(true);
      await AuthService().signinWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _loadController.close();
    _showPasswordController.close();
  }
}
