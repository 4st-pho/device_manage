import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/detail_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/show_custom_dialog.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class DetailDeviceButton extends StatefulWidget {
  final Device device;
  const DetailDeviceButton({Key? key, required this.device}) : super(key: key);

  @override
  State<DetailDeviceButton> createState() => _DetailDeviceButtonState();
}

class _DetailDeviceButtonState extends State<DetailDeviceButton> {
  late final DetailDeviceBloc _detailDeviceBloc;
  void deleteDevice(String deviceId) {
    _detailDeviceBloc.deleteDevice(deviceId).then((_) {
      showCustomSnackBar(context: context, content: AppString.deleteSuccess);
      Navigator.of(context).popUntil(
        (route) =>
            route.settings.name == Routes.mainRoute ||
            route.settings.name == Routes.manageDeviceRoute,
      );
    }).catchError((error) {
      showCustomSnackBar(
          context: context, content: error.toString(), isError: true);
    });
  }

  void recallDevice(String deviceId) {
    _detailDeviceBloc
        .recallDevice(deviceId)
        .then((_) => Navigator.of(context).pop())
        .catchError((error) {
      showCustomSnackBar(
          context: context, content: error.toString(), isError: true);
    });
  }

  @override
  void initState() {
    super.initState();
    _detailDeviceBloc = context.read<DetailDeviceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = (widget.device.ownerId).isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: _buildEditDeviceDevice()),
          const SizedBox(width: 16),
          if (isOwner)
            Expanded(child: _buildRecallButton())
          else
            Expanded(child: _buildDeleteDeviceButton()),
        ],
      ),
    );
  }

  Widget _buildDeleteDeviceButton() {
    return _buildDeviceActionButton(
      text: AppString.delete,
      color: Colors.red,
      dialogColor: Colors.red,
      voidCallback: () => deleteDevice(widget.device.id),
      dialogTitle: AppString.confirm,
      dialogContent: AppString.deviceWillBeDelete,
    );
  }

  Widget _buildRecallButton() {
    return _buildDeviceActionButton(
      text: AppString.recall,
      color: Colors.orange,
      dialogColor: Colors.orange,
      voidCallback: () => recallDevice(widget.device.id),
      dialogTitle: AppString.confirm,
      dialogContent: AppString.deviceWillbeRecall,
    );
  }

  Widget _buildEditDeviceDevice() {
    return CustomButton(
      text: AppString.edit,
      onPressed: () => Navigator.of(context)
          .pushNamed(Routes.editDeviceRoute, arguments: widget.device),
    );
  }

  Widget _buildDeviceActionButton({
    required String text,
    required Color color,
    required VoidCallback voidCallback,
    required String dialogTitle,
    required Color dialogColor,
    required String dialogContent,
  }) {
    return CustomButton(
      text: text,
      color: color,
      onPressed: () => showCustomDialog(
        context: context,
        title: dialogTitle,
        color: dialogColor,
        content: dialogContent,
        onAgree: voidCallback,
      ),
    );
  }
}
