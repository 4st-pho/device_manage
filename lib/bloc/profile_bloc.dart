import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';

class ProfileBloc {
  Future<void> logOut() {
    return AuthService().logOut();
  }

  void dispose() {}
}
