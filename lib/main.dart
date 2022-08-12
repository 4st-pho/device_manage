import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/pages/login/login_page.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/resource/theme_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';
import 'package:manage_devices_app/services/init/init_page.dart';
import 'package:manage_devices_app/services/load/firebase_load.dart';
import 'package:provider/provider.dart';

void main() async {
  await firebaseLoad();
  final skipOnbroad =
      await SharedPreferencesMethod().getBool(key: AppString.skipOnbroading);
  runApp(MyApp(skipOnbroading: skipOnbroad));
}

class MyApp extends StatelessWidget {
  final bool skipOnbroading;
  const MyApp({Key? key, required this.skipOnbroading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) =>
                AuthService(firebaseAuth: FirebaseAuth.instance).authState,
            initialData: null)
      ],
      child: MaterialApp(
        theme: getApplicationTheme(),
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return Scaffold(body: user == null ? const LoginPage() : const InitPage());
  }
}
