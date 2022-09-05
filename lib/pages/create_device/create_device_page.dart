import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/bloc/devices_bloc/create_device_bloc.dart';
import 'package:manage_devices_app/bloc/pick_date_bloc.dart';
import 'package:manage_devices_app/bloc/pick_multi_image_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/helper/show_date_picker.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_form_field/custom_text_form_field.dart';

class CreateDevicePage extends StatefulWidget {
  const CreateDevicePage({Key? key}) : super(key: key);

  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _infoController;
  late final PickDateBloc _pickDateBloc;
  late final createDeviceBloc = CreateDeviceBloc();
  late final PickMultiImageBloc _pickMultiImageBloc;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _infoController = TextEditingController();
    _pickDateBloc = PickDateBloc();
    _pickMultiImageBloc = PickMultiImageBloc();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    _pickDateBloc.dispose();
    _pickMultiImageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameTextField(),
              _buildInfoTextField(),
              _buildLabel('Device type'),
              _buildDeviceTypeDropDown(),
              _buildLabel('Healthy status'),
              _buildHealthyStatusDropDown(),
              _buildLabel('Manufacturing date'),
              _buildPickDate(context),
              _buildLabel('Pick images'),
              _buildPickImage(),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create device',
                onPressed: () {
                  createDeviceBloc.createDevice(
                    formKey: _formKey,
                    name: _nameController.text,
                    info: _infoController.text,
                    date: _pickDateBloc.date,
                    files: _pickMultiImageBloc.images,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<HealthyStatus> _buildHealthyStatusDropDown() {
    return DropdownButtonFormField<HealthyStatus>(
      value: HealthyStatus.good,
      isExpanded: true,
      validator: FormValidate().selectOption,
      decoration: AppDecoration.inputDecoration,
      items: HealthyStatus.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: createDeviceBloc.onHealthyStatusChange,
    );
  }

  DropdownButtonFormField<DeviceType> _buildDeviceTypeDropDown() {
    return DropdownButtonFormField<DeviceType>(
      isExpanded: true,
      validator: FormValidate().selectOption,
      decoration: AppDecoration.inputDecoration,
      items: DeviceType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: createDeviceBloc.onDeviceTypeChange,
    );
  }

  CustomTextFormField _buildInfoTextField() {
    return CustomTextFormField(
      laber: AppString.info,
      controller: _infoController,
      type: TextInputType.multiline,
      validator: FormValidate().contentValidate,
    );
  }

  CustomTextFormField _buildNameTextField() {
    return CustomTextFormField(
      laber: AppString.name,
      controller: _nameController,
      type: TextInputType.text,
      validator: FormValidate().titleValidate,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.createDevice),
      centerTitle: true,
      elevation: 0,
    );
  }

  Row _buildPickDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<DateTime?>(
            stream: _pickDateBloc.stream,
            initialData: null,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? const Text(AppString.chooseDate)
                  : Text(DateFormat('dd MMM yyyy').format(snapshot.data!));
            },
          ),
        ),
        Expanded(
          child: CustomButton(
            text: AppString.chooseDate,
            onPressed: () async {
              final DateTime? date = await showDatePickerCustom(context,
                  initDate: _pickDateBloc.date);
              _pickDateBloc.pickTime(date);
            },
          ),
        ),
      ],
    );
  }

  Wrap _buildPickImage() {
    return Wrap(
      children: [
        StreamBuilder<List<File>?>(
          stream: _pickMultiImageBloc.listImageStream,
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

  Padding _buildSelectImageIcon() {
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label),
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
