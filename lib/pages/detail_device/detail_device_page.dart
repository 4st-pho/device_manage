import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/widgets/owner_info.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/pages/admin/widgets/manage_device.dart';
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
        leading: Container(
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
      ),
      body: StreamBuilder<Device>(
        stream: DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
            .streamDevice(device.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final String error = snapshot.error.toString();
            return Center(
              child: Text(error),
            );
          }
          if (snapshot.hasData) {
            final device = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                                  title: AppString.type,
                                  content: device.deviceType.name),
                              _buildContentItem(
                                  title: AppString.healthyStatus,
                                  content: device.healthyStatus.name),
                              _buildContentItem(
                                  title: AppString.info, content: device.info),
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
                              if (device.ownerId != null)
                                OwnerInfo(
                                  ownerId: device.ownerId ?? '',
                                  ownerType: device.ownerType,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (currentUser!.role == Role.admin)
                  ManageDevice(device: device),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 300,
      width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: device.imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            device.imagePaths[index],
            width: size.width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Column _buildContentItem({required String title, required String content}) {
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
