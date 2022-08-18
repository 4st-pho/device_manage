import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/pages/admin/widgets/manage_device.dart';
import 'package:manage_devices_app/services/clound_firestore/owner_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailDevicePage extends StatelessWidget {
  final Device device;
  const DetailDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    _buildUserInfo(device.ownerId as String),
                  if (currentUser!.role == Role.admin)
                    ManageDevice(device: device),
                ],
              ),
            )
          ],
        ),
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

  FutureBuilder<Map<String, dynamic>> _buildUserInfo(String id) {
    return FutureBuilder<Map<String, dynamic>>(
      future: OwnerMethod(firebaseFirestore: FirebaseFirestore.instance)
          .getOwnerInfo(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data['type'] == 'user') {
            final user = data['data'] as User;
            return _buildInfo(
                imagePath: user.avatar,
                text1: user.name,
                text2: 'Age: ${user.age}',
                text3: 'Address: ${user.address}');
          } else {
            final team = data['data'] as Team;
            return _buildInfo(imagePath: team.imagePath, text1: team.name);
          }
        }
        return ShimmerList.requestInfo;
      },
    );
  }

  Row _buildInfo(
      {required String imagePath,
      required String text1,
      String text2 = '',
      String text3 = ''}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Image.network(
            imagePath,
            height: 150,
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
                style: AppStyle.blueTitle,
              ),
              Text(text2, style: AppStyle.whiteText),
              Text(text3, style: AppStyle.whiteText),
            ],
          ),
        ),
      ],
    );
  }
}
