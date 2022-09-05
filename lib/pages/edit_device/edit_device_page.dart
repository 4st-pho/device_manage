import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/edit_device_bloc.dart';
import 'package:manage_devices_app/bloc/pick_multi_image_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_form_field/custom_text_form_field.dart';

class EditDevicePage extends StatefulWidget {
  final Device device;
  const EditDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  State<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _infoController;
  late final PickMultiImageBloc _pickMultiImageBloc;
  late final EditDeviceBloc _editDeviceBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _infoController = TextEditingController(text: widget.device.info);
    _pickMultiImageBloc = PickMultiImageBloc();
    _editDeviceBloc = EditDeviceBloc(widget.device);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    _pickMultiImageBloc.dispose();
    _editDeviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.editProduct),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      laber: AppString.name,
                      controller: _nameController,
                      type: TextInputType.multiline,
                      validator: FormValidate().titleValidate,
                      onChanged: _editDeviceBloc.onNameChange,
                    ),
                    CustomTextFormField(
                      laber: AppString.info,
                      controller: _infoController,
                      type: TextInputType.multiline,
                      validator: FormValidate().contentValidate,
                      onChanged: _editDeviceBloc.onInfoChange,
                    ),
                    _buildDeviceTypeDropDown(AppString.deviceType),
                    _buildHealthStatusDropDown(AppString.healthyStatus),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(AppString.pickImage),
                    ),
                    _buildPickImage(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: AppString.done,
              onPressed: () => _editDeviceBloc.done(
                _formKey,
                _pickMultiImageBloc.images,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDeviceTypeDropDown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label),
        ),
        DropdownButtonFormField<DeviceType>(
          isExpanded: true,
          value: widget.device.deviceType,
          validator: FormValidate().selectOption,
          decoration: AppDecoration.inputDecoration,
          items: DeviceType.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList(),
          onChanged: _editDeviceBloc.onDeviceTypeChange,
        ),
      ],
    );
  }

  Widget _buildHealthStatusDropDown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label),
        ),
        DropdownButtonFormField<HealthyStatus>(
          isExpanded: true,
          value: widget.device.healthyStatus,
          validator: FormValidate().selectOption,
          decoration: AppDecoration.inputDecoration,
          items: HealthyStatus.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList(),
          onChanged: _editDeviceBloc.onHeathyStatusChange,
        ),
      ],
    );
  }

  Widget _buildPickImage() {
    return Wrap(
      children: [
        StreamBuilder<List<File>?>(
          stream: _pickMultiImageBloc.stream,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              final List<File> data = snapshot.data;
              return Wrap(
                children: [
                  _buildSelectImageIcon(),
                  ...data.map((e) => _buildImage(e)).toList()
                ],
              );
            }
            return _buildSelectImageIcon();
          },
        ),
      ],
    );
  }

  Widget _buildSelectImageIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          await _pickMultiImageBloc.pickImages();
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColor.backgroudNavigation,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.image),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(File file) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColor.backgroudNavigation,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(file, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
