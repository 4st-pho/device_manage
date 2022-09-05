import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
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
      initialData: false,
      builder: (context, snapshot) {
        final isChooseNewDevice = snapshot.data ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(AppString.requestNewDevices),
                Checkbox(
                    activeColor: Colors.blue,
                    value: isChooseNewDevice,
                    onChanged: _createRequestBloc.onCheckBoxNewDevice)
              ],
            ),
            if (isChooseNewDevice &&
                context.read<AppData>().currentUser?.role == Role.leader)
              StreamBuilder<bool>(
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
              ),
            if (isChooseNewDevice) _buildSelectAvailbleDevice(),
            if (!isChooseNewDevice) _buildSelectMyDevice()
          ],
        );
      },
    );
  }

  Widget _buildSelectMyDevice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.errorStatus),
        DropdownButtonFormField<ErrorStatus>(
            isExpanded: true,
            value: _createRequestBloc.deviceErrorStatus,
            validator: FormValidate().selectOption,
            decoration: const InputDecoration(
                filled: true,
                fillColor: AppColor.lightBlack,
                border: OutlineInputBorder(),
                enabledBorder: AppDecoration.outlineInputBorder,
                focusedBorder: AppDecoration.focusOutlineInputBorder),
            items: _createRequestBloc.listErrorStatus
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: _createRequestBloc.changeErrorStatus),
        _buildLabel(AppString.device),
        Consumer<List<Device>>(
          builder: (context, listMyDeviceManage, _) =>
              DropdownButtonFormField<Device>(
            value: _createRequestBloc.myDevide,
            isExpanded: true,
            isDense: false,
            validator: FormValidate().selectOption,
            decoration: AppDecoration.inputDecoration,
            items: listMyDeviceManage
                .map(
                  (device) => DropdownMenuItem(
                    value: device,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            style: AppStyle.whiteText,
                          ),
                          Row(
                            children: [
                              Expanded(child: Text(device.healthyStatus.name)),
                              Text(DateFormat('dd MMM yyyy')
                                  .format(device.manufacturingDate))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: _createRequestBloc.changeDeviceId,
          ),
        ),
      ],
    );
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
                StreamBuilder<Device?>(
                    initialData: _createRequestBloc.avalbleDevice,
                    stream: _createRequestBloc.availbleDeviceStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      final device = snapshot.data;
                      if (device == null) return const Spacer();
                      return Expanded(
                        child:
                            Text(device.name, overflow: TextOverflow.ellipsis),
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
            future: DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                .getAvailableDevice(),
            builder: (context, snapshot) {
              final availableDevices = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: availableDevices.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      _createRequestBloc
                          .onChooseAvailbleDevice(availableDevices[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppDecoration.boxDecoration,
                      child: Text(availableDevices[index].name),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label, style: AppStyle.whiteText),
    );
  }
}
