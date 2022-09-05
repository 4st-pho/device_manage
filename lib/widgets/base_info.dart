import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_style.dart';

class BaseInfo extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  final String text3;
  const BaseInfo(
      {Key? key,
      required this.imagePath,
      required this.text1,
      this.text2 = '',
      this.text3 = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Image.network(
            imagePath,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1.toUpperCase(),
                style: AppStyle.blueText,
              ),
              if (text2.isNotEmpty) Text(text2, style: AppStyle.whiteText),
              if (text3.isNotEmpty) Text(text3, style: AppStyle.whiteText),
            ],
          ),
        ),
      ],
    );
  }
}
