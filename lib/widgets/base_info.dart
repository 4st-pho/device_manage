import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_style.dart';

class BaseInfo extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String info;
  const BaseInfo(
      {Key? key,
      required this.imagePath,
      required this.title,
      this.subtitle = '',
      this.info = ''})
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
                title.toUpperCase(),
                style: AppStyle.blueText,
              ),
              if (subtitle.isNotEmpty) Text(subtitle, style: AppStyle.whiteText),
              if (info.isNotEmpty) Text(info, style: AppStyle.whiteText),
            ],
          ),
        ),
      ],
    );
  }
}
