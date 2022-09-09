import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/helper/show_dialog.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/base_info.dart';
import 'package:manage_devices_app/widgets/owner_info.dart';
import 'package:provider/provider.dart';
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
      appBar: _buildAppBar(),
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
            _buildButton(context)
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.requestDetail),
      centerTitle: true,
    );
  }

  Widget _buildButton(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser!;
    final role = currentUser.role;
    final requestStatus = request.requestStatus;
    if (role == Role.admin) {
      return Padding(
          padding: const EdgeInsets.all(12), child: _buildAdminButon(context));
    } else {
      return role == Role.leader && requestStatus == RequestStatus.pending
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: _buildLeaderButton(context),
            )
          : Container();
    }
  }

  Widget _buildLeaderButton(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDisapprovedButton(context)),
        const SizedBox(width: 24),
        Expanded(child: _buildApprovedButton(context)),
      ],
    );
  }

  Widget _buildApprovedButton(BuildContext context) {
    return CustomButton(
      text: AppString.approved,
      onPressed: () {
        RequestService()
            .updateRequestStatus(request.id, RequestStatus.approved);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildDisapprovedButton(BuildContext context) {
    return CustomButton(
      text: AppString.disapproved,
      onPressed: () {
        RequestService()
            .updateRequestStatus(request.id, RequestStatus.disapproved);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAdminButon(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildRejectButton(context)),
        const SizedBox(width: 24),
        Expanded(child: _buildAcceptButton(context)),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return CustomButton(
      text: AppString.accept,
      onPressed: () {
        RequestService().updateRequestStatus(request.id, RequestStatus.accept);
        if (request.errorStatus == ErrorStatus.noError) {
          DeviceService().provideDevice(
            id: request.deviceId,
            ownerId: request.ownerId,
            ownerType: request.ownerType,
          );
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildRejectButton(BuildContext context) {
    return CustomButton(
      text: AppString.reject,
      color: Colors.red,
      onPressed: () => showCustomDialog(
        context: context,
        title: AppString.confirm,
        content: AppString.deviceWillbeRecall,
        onAgree: () {
          RequestService()
              .updateRequestStatus(request.id, RequestStatus.reject);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return FutureBuilder<Device>(
      future: DeviceService().getDevice(request.deviceId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final device = snapshot.data!;
          return BaseInfo(
              imagePath: device.imagePaths[0],
              title: 'Name: ${device.name}',
              subtitle: 'Type: ${device.deviceType.name}',
              info: 'Healthy status : ${device.healthyStatus.name}');
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
          style: AppStyle.whiteText,
        ),
      ],
    );
  }
}
