import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_icon.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void init() async {
    try {
      final appData = context.read<AppData>();
      await appData.getCurrentUser();
      final currentUser = appData.currentUser!;
      SharedPreferencesMethod.saveUserCredential(currentUser);
    } catch (e) {
      AuthService(firebaseAuth: FirebaseAuth.instance).logOut(context);
      showCustomSnackBar(context: context, content: e.toString(), error: true);
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppIcon.logo,
          width: size.width / 2,
        ),
      ),
    );
  }
}
