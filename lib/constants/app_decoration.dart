import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';

class AppDecoration {
  static const outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: AppColor.lightBlack,
      width: 2,
    ),
  );
  static const focusOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: AppColor.deepBlue,
      width: 2,
    ),
  );
  static const errorOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.red,
      width: 1,
    ),
  );

  static const inputDecoration = InputDecoration(
    filled: true,
    fillColor: AppColor.lightBlack,
    border: OutlineInputBorder(),
    enabledBorder: outlineInputBorder,
    focusedBorder: focusOutlineInputBorder,
    errorBorder: errorOutlineInputBorder,
    focusedErrorBorder: focusOutlineInputBorder,
  );
}
