import 'package:flutter/services.dart';
import 'package:manage_devices_app/constants/app_color.dart';

void loadAppSetting() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColor.backgroudNavigation,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
