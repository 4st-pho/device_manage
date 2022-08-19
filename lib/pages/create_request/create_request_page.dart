import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/request_bloc/create_request_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_form_field/custom_text_form_field.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({Key? key}) : super(key: key);

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _createRequestBloc = CreateRequestBloc();
  final _formKey = GlobalKey<FormState>();
  // final List<ErrorStatus> _listError = [
  //   ErrorStatus.hardware,
  //   ErrorStatus.hardware
  // ];

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _createRequestBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser!;
    final userDevice = context.read<AppData>().myDevice;
    List<Device> myAllDevice = userDevice;
    if (currentUser.role == Role.leader) {
      final teamDevice = context.read<AppData>().teamDevice;
      myAllDevice = [...userDevice, ...teamDevice];
    }
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.createRequest),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          laber: AppString.title,
                          controller: _titleController,
                          type: TextInputType.multiline,
                          validator: FormValidate().titleValidate,
                        ),
                        CustomTextFormField(
                          laber: AppString.content,
                          controller: _contentController,
                          type: TextInputType.multiline,
                          validator: FormValidate().contentValidate,
                        ),
                        _buildSelectDevice(myAllDevice),
                        const SizedBox(height: 40),
                      ]),
                ),
              ),
            ),
            CustomButton(
              text: AppString.send,
              onPressed: () => _createRequestBloc.sendData(
                _titleController.text,
                _contentController.text,
                _formKey,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<bool> _buildSelectDevice(List<Device> myAllDevice) {
    return StreamBuilder<bool>(
      stream: _createRequestBloc.stream,
      initialData: false,
      builder: (context, snapshot) {
        final chooseNewDevice = snapshot.data ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(AppString.requestNewDevices),
                Checkbox(
                    activeColor: Colors.blue,
                    value: chooseNewDevice,
                    onChanged: _createRequestBloc.onCheckBoxNewDevice)
              ],
            ),
            if (chooseNewDevice)
              _buildSelectBox(
                lable: 'Availble device',
                initdata: _createRequestBloc.avalbleDevice,
                onTap: () => _showBottomSheetChooseValue(
                    context, _createRequestBloc.onChooseAvailbleDevice),
                stream: _createRequestBloc.streamAvailbleDevice,
              ),
            if (!chooseNewDevice) _buildSelectMyDevice(myAllDevice)
          ],
        );
      },
    );
  }

  Column _buildSelectMyDevice(List<Device> myAllDevice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.errorStatus),
        DropdownButtonFormField<ErrorStatus>(
            isExpanded: true,
            value: _createRequestBloc.request.errorStatus,
            decoration: const InputDecoration(
                filled: true,
                fillColor: AppColor.lightBlack,
                border: OutlineInputBorder(),
                enabledBorder: AppDecoration.outlineInputBorder,
                focusedBorder: AppDecoration.focusOutlineInputBorder),
            items: ErrorStatus.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: _createRequestBloc.changeErrorStatus),
        _buildLabel(AppString.device),
        DropdownButtonFormField<Device>(
          value: _createRequestBloc.mydevice,
          isExpanded: true,
          isDense: false,
          validator: FormValidate().selectOption,
          decoration: AppDecoration.inputDecoration,
          items: myAllDevice
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: AppStyle.whiteText,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(e.healthyStatus.name)),
                            Text(DateFormat('dd MMM yyyy')
                                .format(e.manufacturingDate))
                          ],
                        ),
                      ],
                    ),
                  )))
              .toList(),
          onChanged: _createRequestBloc.changeDeviceId,
        ),
      ],
    );
  }

  Column _buildLabel(String label) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(label, style: AppStyle.whiteText),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<dynamic> _showBottomSheetChooseValue(
      BuildContext context, void Function(Device) handle) {
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
              final data = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      handle(data[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppDecoration.boxDecoration,
                      child: Text(data[index].name),
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

  Column _buildSelectBox(
      {required VoidCallback onTap,
      Device? initdata,
      required String lable,
      required Stream<Device?> stream}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(lable),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<Device?>(
                    initialData: initdata,
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      final data = snapshot.data;
                      if (data == null) {
                        return const Spacer();
                      }
                      return Expanded(
                        child: Text(data.name, overflow: TextOverflow.ellipsis),
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
}
