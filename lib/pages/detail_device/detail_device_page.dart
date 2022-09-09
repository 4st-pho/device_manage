import 'package:manage_devices_app/pages/detail_device/widgets/detail_device_button.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/widgets/owner_info.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailDevicePage extends StatelessWidget {
  final Device device;
  const DetailDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.keyboard_backspace_outlined,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Device>(
              stream: DeviceService().streamDevice(device.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final String error = snapshot.error.toString();
                  return Center(
                    child: Text(error),
                  );
                }
                if (snapshot.hasData) {
                  final deviceStream = snapshot.data!;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImage(context, deviceStream),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildContentItem(
                                  title: AppString.name,
                                  content: deviceStream.name),
                              _buildContentItem(
                                  title: AppString.type,
                                  content: deviceStream.deviceType.name),
                              _buildContentItem(
                                  title: AppString.healthyStatus,
                                  content: deviceStream.healthyStatus.name),
                              _buildContentItem(
                                  title: AppString.info,
                                  content: deviceStream.info),
                              if (deviceStream.transferDate != null)
                                _buildContentItem(
                                  title: AppString.transferDate,
                                  content: DateFormat('dd MMM yyyy')
                                      .format(deviceStream.transferDate!),
                                ),
                              _buildContentItem(
                                title: AppString.manufacturingDate,
                                content: DateFormat('dd MMM yyyy')
                                    .format(deviceStream.manufacturingDate),
                              ),
                              if (deviceStream.ownerId != null)
                                OwnerInfo(
                                  ownerId: deviceStream.ownerId ?? '',
                                  ownerType: deviceStream.ownerType,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          if (currentUser!.role == Role.admin)
            DetailDeviceButton(device: device),
        ],
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    Device deviceStream,
  ) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 300,
      width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: deviceStream.imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            deviceStream.imagePaths[index],
            width: size.width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildContentItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextDivider(text: title),
        Text(content, style: AppStyle.whiteText),
      ],
    );
  }
}
