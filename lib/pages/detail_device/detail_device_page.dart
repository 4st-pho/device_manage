import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_font.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailDevicePage extends StatelessWidget {
  final Device device;
  const DetailDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentItem(
                      title: AppString.name, content: device.name),
                  _buildContentItem(
                      title: AppString.type, content: device.deviceType.name),
                  _buildContentItem(
                      title: AppString.info, content: device.info),
                  // _buildContentItem(
                  //   title: AppString.quantity,
                  //   content: orderDevice.quantity.toString(),
                  // ),
                  if (device.transferDate != null)
                    _buildContentItem(
                      title: AppString.transferDate,
                      content: DateFormat('dd MMM yyyy')
                          .format(device.transferDate!),
                    ),
                  _buildContentItem(
                    title: AppString.manufacturingDate,
                    content: DateFormat('dd MMM yyyy')
                        .format(device.manufacturingDate),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack _buildImage(BuildContext context) {
    return Stack(children: [
      Image.network(
        device.imagePaths.first,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      ),
      Positioned(
        left: 10,
        top: 40,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.2),
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.keyboard_backspace_outlined,
            ),
          ),
        ),
      )
    ]);
  }

  Column _buildContentItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextDivider(text: title),
        Text(content, style: AppFont.whiteText),
      ],
    );
  }
}
