import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_style.dart';

class ProfileItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const ProfileItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color = AppColor.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: AppStyle.whiteTitle)),
          ],
        ),
      ),
    );
  }
}
