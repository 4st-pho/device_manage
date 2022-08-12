import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_font.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/fade_image.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.detailDeviceRoute, arguments: device),
      child: Card(
        color: Colors.blue.withOpacity(.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeImageWidget(imagePath: device.imagePaths.first),
            _buildCardContent()
          ],
        ),
      ),
    );
  }

  Padding _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.name.toUpperCase(),
            style: AppFont.blueTitle,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'TYPE:  ${device.deviceType.name}',
                  style: AppFont.whiteText,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'MFG: ${DateFormat("dd MMM yyyy").format(device.manufacturingDate)}',
                style: AppFont.whiteText,
              ),
            ],
          )
        ],
      ),
    );
  }
}
