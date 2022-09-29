import 'package:manage_devices_app/bloc/request_bloc/detail_request_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/helper/show_custom_dialog.dart';
import 'package:manage_devices_app/pages/request_detail/widgets/request_owner_info.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/base_info.dart';
import 'package:manage_devices_app/widgets/not_found.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailRequestPage extends StatefulWidget {
  final Request request;
  const DetailRequestPage({Key? key, required this.request}) : super(key: key);

  @override
  State<DetailRequestPage> createState() => _DetailRequestPageState();
}

class _DetailRequestPageState extends State<DetailRequestPage> {
  late final DetailRequestBloc _detailRequestBloc;
  void updateRequestStatus(RequestStatus requestStatus) {
    showCustomDialog(
      context: context,
      title: AppString.confirm,
      content: AppString.theProcessWillContinue,
      onAgree: () {
        _detailRequestBloc
            .updateRequestStatus(widget.request.id, requestStatus)
            .then((_) => Navigator.popUntil(
                context, ModalRoute.withName(Routes.mainRoute)))
            .catchError(
          (error) {
            showCustomSnackBar(
              context: context,
              content: error.toString(),
            );
          },
        );
      },
    );
  }

  void acceptRequest() {
    showCustomDialog(
      context: context,
      title: AppString.confirm,
      content: AppString.theProcessWillContinue,
      onAgree: () {
        _detailRequestBloc.acceptRequest(widget.request).then((_) {
          Navigator.popUntil(context, ModalRoute.withName(Routes.mainRoute));
        }).catchError(
          (error) {
            Navigator.of(context).pop();
            showCustomSnackBar(
              context: context,
              content: error.toString(),
              isError: true,
            );
          },
        );
      },
    );
  }

  void rejectRequest() {
    showCustomDialog(
      context: context,
      title: AppString.confirm,
      content: AppString.requestWillBeReject,
      color: Colors.redAccent,
      onAgree: () {
        _detailRequestBloc
            .updateRequestStatus(widget.request.id, RequestStatus.reject)
            .then((_) => Navigator.popUntil(
                context, ModalRoute.withName(Routes.mainRoute)))
            .catchError(
          (error) {
            showCustomSnackBar(
                context: context, content: error.toString(), isError: true);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _detailRequestBloc = context.read<DetailRequestBloc>();
    _detailRequestBloc.setRealtimeRequestStatus(widget.request.id);
  }

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
                  RequestOwnerInfo(
                    ownerId: widget.request.ownerId,
                    ownerType: widget.request.ownerType,
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
          _buildShowHideProcessButton()
        ],
      ),
    );
  }

  Widget _buildShowHideProcessButton() {
    return StreamBuilder<RequestStatus>(
      initialData: widget.request.requestStatus,
      stream: _detailRequestBloc.requestStatusStream,
      builder: (context, snapshot) {
        final requestStatus = snapshot.data ?? RequestStatus.reject;
        if (requestStatus == RequestStatus.pending ||
            requestStatus == RequestStatus.approved) {
          return _buildButton(requestStatus);
        }
        return const SizedBox.shrink();
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: const Text(AppString.requestDetail),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildButton(RequestStatus requestStatus) {
    final currentUser = context.read<AppData>().currentUser!;
    final role = currentUser.role;
    if (role == Role.admin) {
      return Padding(
          padding: const EdgeInsets.all(12), child: _buildAdminButon(context));
    } else {
      final isLeaderPermission =
          role == Role.leader && requestStatus == RequestStatus.pending;
      return isLeaderPermission
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: _buildLeaderButton(context),
            )
          : const SizedBox.shrink();
    }
  }

  Widget _buildLeaderButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildUpdateRequestStatusButton(
              AppString.disapproved, RequestStatus.disapproved, Colors.red),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildUpdateRequestStatusButton(
              AppString.approved, RequestStatus.approved, AppColor.dartBlue),
        ),
      ],
    );
  }

  Widget _buildUpdateRequestStatusButton(
      String text, RequestStatus requestStatus, Color color) {
    return StreamBuilder<bool>(
      stream: _detailRequestBloc.loadStream,
      initialData: false,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;
        return CustomButton(
          text: text,
          color: color,
          onPressed:
              isLoading ? null : () => updateRequestStatus(requestStatus),
        );
      },
    );
  }

  Widget _buildAdminButon(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildRejectButton()),
        const SizedBox(width: 24),
        Expanded(child: _buildAcceptButton()),
      ],
    );
  }

  Widget _buildAcceptButton() {
    return StreamBuilder<bool>(
      stream: _detailRequestBloc.loadStream,
      initialData: false,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;
        return CustomButton(
          text: AppString.accept,
          onPressed: isLoading ? null : () => acceptRequest(),
        );
      },
    );
  }

  Widget _buildRejectButton() {
    return StreamBuilder<bool>(
      stream: _detailRequestBloc.loadStream,
      initialData: false,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;
        return CustomButton(
          text: AppString.reject,
          color: Colors.red,
          onPressed: isLoading ? null : () => rejectRequest(),
        );
      },
    );
  }

  Widget _buildDeviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDivider(text: AppString.deviceInfo),
        _buildDeviceInfoContent(),
      ],
    );
  }

  Widget _buildDeviceInfoContent() {
    return FutureBuilder<Device?>(
      future: _detailRequestBloc.getDevice(widget.request.deviceId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final String error = snapshot.error.toString();
          return Center(child: Text(error));
        }
        if (!snapshot.hasData) return const NotFound();
        final device = snapshot.data!;
        return BaseInfo(
          imagePath: device.imagePaths[0],
          title: 'Name: ${device.name}',
          subtitle: 'Type: ${device.deviceType.name}',
          info: 'Healthy status : ${device.healthyStatus.name}',
        );
      },
    );
  }

  Widget _buildRequestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequestStatusInfo(),
        _buildRequestInfoItem(AppString.title, widget.request.title),
        _buildRequestInfoItem(AppString.content, widget.request.content),
        if (widget.request.errorType == ErrorType.noError)
          _buildRequestInfoItem(AppString.requestNewDevice, AppString.yes)
        else
          _buildRequestInfoItem(
              AppString.errortype, widget.request.errorType.name),
      ],
    );
  }

  Widget _buildRequestStatusInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDivider(text: AppString.status),
        Text(
            'Time: ${DateFormat("dd MMM yyyy").format(widget.request.createdAt)}'),
        Text('Status: ${widget.request.requestStatus.name}'),
      ],
    );
  }

  Widget _buildRequestInfoItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextDivider(text: title),
        Text(content, style: AppStyle.whiteText),
      ],
    );
  }
}
