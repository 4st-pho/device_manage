import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_style.dart';

class TextDivider extends StatelessWidget {
  final String text;
  const TextDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(flex: 1, child: Divider(thickness: 2)),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppStyle.blueTitle,
          ),
          const SizedBox(width: 4),
          const Expanded(
            flex: 10,
            child: Divider(thickness: 2),
          ),
        ],
      ),
    );
  }
}
