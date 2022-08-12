import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          CustomButton(
            text: 'click me!',
            onPressed: () async {
              AuthService(firebaseAuth: FirebaseAuth.instance).logOut(context: context);
                  // .signUpWithEmailAndPassword(email: 'admin2@gmail.com', password: '123123123', context: context);
            },
          )
        ],
      ),
    );
  }
}
 