import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/provide_device_bloc.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/pages/provide_device/widget/bottom_sheet_choose_team.dart';
import 'package:manage_devices_app/pages/provide_device/widget/bottom_sheet_choose_user.dart';
import 'package:provider/provider.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';

class ProvideDevicePage extends StatefulWidget {
  final Device device;
  const ProvideDevicePage({Key? key, required this.device}) : super(key: key);
  @override
  State<ProvideDevicePage> createState() => _ProvideDevicePageState();
}

class _ProvideDevicePageState extends State<ProvideDevicePage> {
  late final ProvideDeviceBloc _proviceDeviceBloc;

  void provideDevice() {
    _proviceDeviceBloc.provideDevice(widget.device.id).then((_) {
      showCustomSnackBar(
          context: context, content: AppString.provideDeviceSuccess);
      Navigator.of(context).pop();
    }).catchError((error) {
      showCustomSnackBar(
          context: context, content: error.toString(), isError: true);
    });
  }

  @override
  void initState() {
    _proviceDeviceBloc = context.read<ProvideDeviceBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildInfo(), _buildContent()],
              ),
            ),
          ),
          _buildProvideDeviceButton(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<OwnerType>(
      initialData: OwnerType.user,
      stream: _proviceDeviceBloc.chooseOwnerTypeStream,
      builder: (context, snapshot) {
        final ownerType = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChooseOwnerTypeDropdownButton(ownerType),
            if (ownerType == OwnerType.user)
              const BottomSheetChooseUser()
            else
              const BottomSheetChooseTeam()
          ],
        );
      },
    );
  }

  Widget _buildChooseOwnerTypeDropdownButton(OwnerType? ownerType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButton(
        value: ownerType,
        items: _proviceDeviceBloc.listOwnerType
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ))
            .toList(),
        onChanged: _proviceDeviceBloc.onOwnerTypeChange,
      ),
    );
  }

  Widget _buildProvideDeviceButton() {
    return StreamBuilder<bool>(
      stream: _proviceDeviceBloc.loadStream,
      initialData: false,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: CustomButton(
            text: AppString.provide,
            onPressed: isLoading ? null : () => provideDevice(),
          ),
        );
      },
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: const Text(AppString.provideDevice),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfo() {
    final String healthDevice = widget.device.healthyStatus.name;
    final String typeOfDevice = widget.device.deviceType.name;
    return ListTile(
      title: Text(
        widget.device.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(healthDevice),
      trailing: Text(typeOfDevice),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Image.network(
          widget.device.imagePaths[0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
