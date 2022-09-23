import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';

void showCustomDialog(
    {required BuildContext context,
    required String title,
    required String content,
    bool isShowOnlyCancelbutton = false,
    Color color = Colors.black87,
    required VoidCallback onAgree}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      actions: <Widget>[
        OutlinedButton(
            style: OutlinedButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(AppString.cancel)),
        if (!isShowOnlyCancelbutton)
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: AppColor.dartBlue),
            onPressed: onAgree,
            child: const Text(
              AppString.ok,
              style: AppStyle.whiteText,
            ),
          ),
      ],
    ),
  );
}
