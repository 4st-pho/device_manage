import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/helper/show_dialog.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/base_info.dart';
import 'package:manage_devices_app/widgets/owner_info.dart';
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
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
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
                  OwnerInfo(
                    ownerId: request.ownerId,
                    ownerType: request.ownerType,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildRequestInfo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDeviceInfo(),
                  ),
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

  Widget _buildButtom(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser!;
    final role = currentUser.role;
    final requestStatus = request.requestStatus;
    return role == Role.admin
        ? Padding(
            padding: const EdgeInsets.all(12), child: _buildAdminButon(context))
        : (role == Role.leader && requestStatus == RequestStatus.pending)
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: _buildLeaderButton(context),
              )
            : Container();
  }

  Widget _buildLeaderButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppString.disapproved,
            onPressed: () {
              RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                  .updateStatusRequest(request.id, RequestStatus.disapproved);
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: CustomButton(
            text: AppString.approved,
            onPressed: () {
              RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                  .updateStatusRequest(request.id, RequestStatus.approved);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminButon(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
              text: AppString.reject,
              color: Colors.red,
              onPressed: () => showCustomDialog(
                  context: context,
                  title: AppString.confirm,
                  content: AppString.requestWillBeReject,
                  onAgree: () {
                    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .updateStatusRequest(request.id, RequestStatus.reject);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  })),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: CustomButton(
            text: AppString.accept,
            onPressed: () {
              RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
                  .updateStatusRequest(request.id, RequestStatus.accept);
              if (request.errorStatus == ErrorStatus.noError) {
                DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                    .provideDevice(
                  id: request.deviceId,
                  ownerId: request.ownerId,
                  ownerType: request.ownerType,
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }

  FutureBuilder<Device> _buildDeviceInfo() {
    return FutureBuilder<Device>(
      future: DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
          .getDevice(request.deviceId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final device = snapshot.data!;
          return BaseInfo(
              imagePath: device.imagePaths[0],
              text1: 'Name: ${device.name}',
              text2: 'Type: ${device.deviceType.name}',
              text3: 'Healthy status : ${device.healthyStatus.name}');
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
        Text(
            request.errorStatus == ErrorStatus.noError
                ? AppString.requestNewDevice
                : request.errorStatus.name,
            style: AppStyle.whiteText),
      ],
    );
  }
}
