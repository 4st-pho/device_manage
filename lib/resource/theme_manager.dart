import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColor.background,
    colorScheme: const ColorScheme.dark(),
    dividerColor: AppColor.grey,
  );
}
