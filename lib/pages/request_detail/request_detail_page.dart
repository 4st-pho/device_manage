import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_font.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device_category.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_category_method.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (currentUser!.role == Role.admin)
            Expanded(
              child: CustomButton(
                text: AppString.refuse,
                color: Colors.red,
                onPressed: () =>
                    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .updateStatusRequest(
                            request.id, RequestStatus.refuse, context),
              ),
            ),
          if (currentUser!.role == Role.admin) const SizedBox(width: 24),
          if (currentUser!.role == Role.leader &&
              request.requestStatus == RequestStatus.pending)
            Expanded(
              child: CustomButton(
                text: AppString.approved,
                onPressed: () =>
                    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .updateStatusRequest(
                            request.id, RequestStatus.approved, context),
              ),
            ),
          if (currentUser!.role == Role.admin)
            Expanded(
              child: CustomButton(
                text: AppString.accept,
                onPressed: () =>
                    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .updateStatusRequest(
                            request.id, RequestStatus.accept, context),
              ),
            ),
        ],
      ),
    );
  }

  FutureBuilder<DeviceCategory> _buildDeviceInfo() {
    return FutureBuilder<DeviceCategory>(
      future:
          DeviceCategoryMethod(firebaseFirestore: FirebaseFirestore.instance)
              .getDeviceCategory(request.deviceCategoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final deviceCategory = snapshot.data!;
          return _buildInfo(
              imagePath: deviceCategory.imagePath,
              text1: deviceCategory.name,
              text2: '',
              text3: '');
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return ShimmerList.requestInfo;
      },
    );
  }

  Column _buildRequestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time: ${DateFormat("dd MMM yyyy").format(request.createdAt)}'),
        Text('Status: ${request.requestStatus.name}'),
        const TextDivider(text: AppString.title),
        Text(request.title, style: AppFont.whiteText),
        const TextDivider(text: AppString.content),
        Text(request.content, style: AppFont.whiteText),
        const TextDivider(text: AppString.errorStatus),
        Text(request.errorStatus.name, style: AppFont.whiteText),
      ],
    );
  }

  FutureBuilder<User> _buildUserInfo() {
    return FutureBuilder<User>(
      future: UserMethod(firebaseFirestore: FirebaseFirestore.instance)
          .getUser(uid: request.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return _buildInfo(
              imagePath: user.avatar,
              text1: user.name,
              text2: 'Age: ${user.age}',
              text3: 'Address: ${user.address}');
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
      required String text1,
      required String text2,
      required String text3}) {
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
                style: AppFont.blueTitle,
              ),
              Text(text2, style: AppFont.whiteText),
              Text(text3, style: AppFont.whiteText),
            ],
          ),
        ),
      ],
    );
  }
}
