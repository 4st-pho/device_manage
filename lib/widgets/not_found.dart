import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_image.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Image.asset(
          AppImage.notFound,
          width: size.width / 3,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
