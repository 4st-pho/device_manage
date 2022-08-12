import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_image.dart';

class FadeImageWidget extends StatelessWidget {
  final String imagePath;
  const FadeImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16)
      ),
      child: FadeInImage.assetNetwork(
        placeholder: AppImage.fadeImage,
        image: imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ),
    );
  }
}
