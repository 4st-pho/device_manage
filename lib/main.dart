import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/onbroad_bloc.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/pages/login/login_page.dart';
import 'package:manage_devices_app/pages/onbroad/onbroad_page.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/resource/theme_manager.dart';
import 'package:manage_devices_app/services/load/firebase_load.dart';
import 'package:manage_devices_app/services/splash/splash_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await firebaseLoad();
  final skipOnbroad = await SharedPreferencesMethod.getSkipOnbroading();
  runApp(MyApp(skipOnbroading: skipOnbroad));
}

class MyApp extends StatelessWidget {
  final bool skipOnbroading;
  const MyApp({Key? key, required this.skipOnbroading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppData(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          theme: getApplicationTheme(),
          onGenerateRoute: RouteGenerator.getRoute,
          debugShowCheckedModeBanner: false,
          home: skipOnbroading
              ? const AuthWrapper()
              : Provider<OnbroadBloc>(
                  create: (context) => OnbroadBloc(),
                  dispose: (_, prov) => prov.dispose(),
                  child: const OnbroadPage(),
                ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return const SplashPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
