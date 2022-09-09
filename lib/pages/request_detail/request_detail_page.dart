import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailRequestPage extends StatelessWidget {
  final Request request;
  const DetailRequestPage({Key? key, required this.request}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.requestDetail),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildUserInfo(),
                  const SizedBox(height: 40),
                  _buildRequestInfo(),
                  _buildDeviceInfo(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (request.requestStatus == RequestStatus.pending ||
              request.requestStatus == RequestStatus.approved)
            _buildButtom(context)
        ],
      ),
    );
  }

  Padding _buildButtom(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (currentUser!.role == Role.admin)
            Expanded(
              child: CustomButton(
                text: AppString.reject,
                color: Colors.red,
                onPressed: () => RequestService()
                    .updateRequestStatus(request.id, RequestStatus.reject),
              ),
            ),
          if (currentUser.role == Role.admin) const SizedBox(width: 24),
          if (currentUser.role == Role.leader &&
              request.requestStatus == RequestStatus.pending)
            Expanded(
              child: CustomButton(
                text: AppString.approved,
                onPressed: () => RequestService().updateRequestStatus(
                  request.id,
                  RequestStatus.approved,
                ),
              ),
            ),
          if (currentUser.role == Role.admin)
            Expanded(
              child: CustomButton(
                text: AppString.accept,
                onPressed: () => RequestService()
                    .updateRequestStatus(request.id, RequestStatus.accept),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return FutureBuilder<Device>(
      future: DeviceService().getDevice(request.deviceId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final device = snapshot.data!;
          return _buildInfo(
              imagePath: device.imagePaths[0],
              title: device.name,
              subtitle: '',
              info: '');
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return ShimmerList.requestInfo;
      },
    );
  }

  Widget _buildRequestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time: ${DateFormat("dd MMM yyyy").format(request.createdAt)}'),
        Text('Status: ${request.requestStatus.name}'),
        const TextDivider(text: AppString.title),
        Text(request.title, style: AppStyle.whiteText),
        const TextDivider(text: AppString.content),
        Text(request.content, style: AppStyle.whiteText),
        const TextDivider(text: AppString.errorStatus),
        Text(request.errorStatus.name, style: AppStyle.whiteText),
      ],
    );
  }

  FutureBuilder<User> _buildUserInfo() {
    return FutureBuilder<User>(
      future: UserMethod(firebaseFirestore: FirebaseFirestore.instance)
          .getUser(request.ownerId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return _buildInfo(
              imagePath: user.avatar,
              title: user.name,
              subtitle: 'Age: ${user.age}',
              info: 'Address: ${user.address}');
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return ShimmerList.requestInfo;
      },
    );
  }

  Row _buildInfo(
      {required String imagePath,
      required String title,
      required String subtitle,
      required String info}) {
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
                title.toUpperCase(),
                style: AppStyle.blueTitle,
              ),
              Text(subtitle, style: AppStyle.whiteText),
              Text(info, style: AppStyle.whiteText),
            ],
          ),
        ),
      ],
    );
  }
}
