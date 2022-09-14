import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/request_bloc/create_request_bloc.dart';

class SelectDeviceWidget extends StatefulWidget {
  const SelectDeviceWidget({Key? key}) : super(key: key);

  @override
  State<SelectDeviceWidget> createState() => _SelectDeviceWidgetState();
}

class _SelectDeviceWidgetState extends State<SelectDeviceWidget> {
  late final CreateRequestBloc _createRequestBloc;
  @override
  void initState() {
    super.initState();
    _createRequestBloc = context.read<CreateRequestBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _createRequestBloc.isRequestNewDeviceStream,
      // initialData: _createRequestBloc.isRequestNewDevice,
      builder: (context, snapshot) {
        final isChooseNewDevice = snapshot.data ?? false;
        final isLeaderChooseNewDevice = isChooseNewDevice &&
            context.read<AppData>().currentUser?.role == Role.leader;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckBoxNewDevice(isChooseNewDevice),
            if (isLeaderChooseNewDevice) _buildCheckBoxCreateRequestForTeam(),
            if (isChooseNewDevice)
              _buildSelectAvailbleDevice()
            else
              _buildSelectMyDevice(),
          ],
        );
      },
    );
  }

  StreamBuilder<bool> _buildCheckBoxCreateRequestForTeam() {
    return StreamBuilder<bool>(
      stream: _createRequestBloc.isRequestFromTeamStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final bool isRequestFromTeam = snapshot.data ?? false;
        return Row(
          children: [
            const Text(AppString.createRequestForTeam),
            Checkbox(
              activeColor: Colors.blue,
              value: isRequestFromTeam,
              onChanged: _createRequestBloc.onCheckRequestFromTeam,
            )
          ],
        );
      },
    );
  }

  Row _buildCheckBoxNewDevice(bool isChooseNewDevice) {
    return Row(
      children: [
        const Text(AppString.requestNewDevices),
        Checkbox(
          activeColor: Colors.blue,
          value: isChooseNewDevice,
          onChanged: _createRequestBloc.onCheckNewDevice,
        )
      ],
    );
  }

  Widget _buildSelectMyDevice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.errorStatus),
        _buildDropdownButtonErrorStatus(),
        _buildLabel(AppString.device),
        _buildDropdownButtonSelectMyDeviceManage(),
      ],
    );
  }

  Widget _buildDropdownButtonSelectMyDeviceManage() {
    return StreamBuilder<List<Device>>(
      stream: _createRequestBloc.myDevicesStream,
      builder: (context, snapshot) {
        final myDevices = snapshot.data ?? [];
        return DropdownButtonFormField<Device>(
          value: _createRequestBloc.myDevide,
          isExpanded: true,
          isDense: false,
          validator: FormValidate().selectOption,
          decoration: AppDecoration.inputDecoration,
          items: myDevices.map((device) {
            final String healthStatus = device.healthyStatus.name;
            return DropdownMenuItem(
              value: device,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name, style: AppStyle.whiteText),
                    Row(children: [
                      Expanded(child: Text(healthStatus)),
                      Text(DateFormat('dd MMM yyyy')
                          .format(device.manufacturingDate))
                    ]),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: _createRequestBloc.onChooseMyDevice,
        );
      },
    );
  }

  Widget _buildDropdownButtonErrorStatus() {
    return DropdownButtonFormField<ErrorStatus>(
        isExpanded: true,
        value: _createRequestBloc.deviceErrorStatus,
        validator: FormValidate().selectOption,
        decoration: const InputDecoration(
            filled: true,
            fillColor: AppColor.lightBlack,
            border: OutlineInputBorder(),
            enabledBorder: AppDecoration.outlineInputBorder,
            focusedBorder: AppDecoration.focusOutlineInputBorder),
        items: [ErrorStatus.software, ErrorStatus.hardware]
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        onChanged: _createRequestBloc.onChangeErrorStatus);
  }

  Widget _buildSelectAvailbleDevice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(AppString.availableDevice),
        ),
        InkWell(
          onTap: () => _showBottomSheetChooseValue(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<String?>(
                    initialData: null,
                    stream: _createRequestBloc.availbleDeviceStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        final String error = snapshot.error.toString();
                        return Center(child: Text(error));
                      }
                      final deviceName = snapshot.data;
                      if (deviceName == null) return const Spacer();
                      return Expanded(
                        child:
                            Text(deviceName, overflow: TextOverflow.ellipsis),
                      );
                    }),
                const SizedBox(width: 14),
                const Icon(Icons.unfold_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showBottomSheetChooseValue() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FutureBuilder<List<Device>>(
            initialData: const [],
            future: DeviceService().getAvailableDevice(),
            builder: (context, snapshot) {
              final availableDevices = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: availableDevices.length,
                itemBuilder: (ctx, index) {
                  final device = availableDevices[index];

                  return _buildSelectAvailbleItem(device);
                },
              );
            },
          ),
        );
      },
    );
  }

  InkWell _buildSelectAvailbleItem(Device device) {
    final healthStatus = device.healthyStatus.name;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _createRequestBloc.onChooseAvailbleDevice(device);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: AppDecoration.boxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.name, style: AppStyle.whiteText),
            Row(children: [
              Expanded(child: Text(healthStatus)),
              Text(DateFormat('dd MMM yyyy').format(device.manufacturingDate))
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label, style: AppStyle.whiteText),
    );
  }
}
