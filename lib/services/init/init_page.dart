import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_icon.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/init/init_method.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  void init() async {
    try {
      await InitMethod().getCurrentUser();
      InitMethod().getUserSameTeam();
      InitMethod().getAllDeviceCategory();
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
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
