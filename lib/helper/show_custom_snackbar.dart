import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_style.dart';
void showCustomSnackBar({
  required BuildContext context,
  required String content,
  String title = '',
  bool error = false,
  int milisecond = 2000,
}) {
  final snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty)
          Row(children: [
            Expanded(
              child: Text(
                title.trim().toUpperCase(),
                style: error ? AppStyle.redText : AppStyle.whiteText,
              ),
            ),
          ]),
        if (title.isNotEmpty) const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                content.trim(),
                style: error ? AppStyle.redText : AppStyle.whiteText,
              ),
            ),
          ],
        ),
      ],
    ),
    duration: Duration(milliseconds: milisecond),
    backgroundColor: Colors.black.withOpacity(.6),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    // margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    // behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
