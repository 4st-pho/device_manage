import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:manage_devices_app/bloc/devices_bloc/create_device_bloc.dart';
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
  late final CreateDeviceBloc _createDeviceBloc;
  final _formKey = GlobalKey<FormState>();
  void createDevice() {
    if (_formKey.currentState!.validate()) {
      _createDeviceBloc.createDevice().then((_) {
        showCustomSnackBar(context: context, content: AppString.createSuccess);
        Navigator.of(context).pop();
      }).catchError((error) {
        showCustomSnackBar(
            context: context, content: error.toString(), error: true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _infoController = TextEditingController();
    _createDeviceBloc = context.read<CreateDeviceBloc>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
                    _buildNameTextField(),
                    _buildInfoTextField(),
                    _buildLabel(AppString.deviceType),
                    _buildDeviceTypeDropDown(),
                    _buildLabel(AppString.healthyStatus),
                    _buildHealthyStatusDropDown(),
                    _buildLabel(AppString.manufacturingDate),
                    _buildPickDate(context),
                    _buildLabel(AppString.pickImage),
                    _buildPickImage(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: _createDeviceBloc.loadStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: AppString.createDevice,
                  onPressed: isLoading ? null : () => createDevice(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthyStatusDropDown() {
    return DropdownButtonFormField<HealthyStatus>(
      value: HealthyStatus.good,
      isExpanded: true,
      validator: FormValidate().selectOption,
      decoration: AppDecoration.inputDecoration,
      items: HealthyStatus.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: _createDeviceBloc.onHealthyStatusChange,
    );
  }

  Widget _buildDeviceTypeDropDown() {
    return DropdownButtonFormField<DeviceType>(
      isExpanded: true,
      validator: FormValidate().selectOption,
      decoration: AppDecoration.inputDecoration,
      items: DeviceType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: _createDeviceBloc.onDeviceTypeChange,
    );
  }

  Widget _buildInfoTextField() {
    return CustomTextFormField(
      laber: AppString.info,
      controller: _infoController,
      type: TextInputType.multiline,
      validator: FormValidate().contentValidate,
      onChanged: _createDeviceBloc.onInfoChange,
    );
  }

  Widget _buildNameTextField() {
    return CustomTextFormField(
      laber: AppString.name,
      controller: _nameController,
      type: TextInputType.text,
      validator: FormValidate().titleValidate,
      onChanged: _createDeviceBloc.onNameChange,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.createDevice),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildPickDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<DateTime?>(
            stream: _createDeviceBloc.datePickerStream,
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
                  initDate: _createDeviceBloc.datePicked);
              _createDeviceBloc.pickDate(date);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPickImage() {
    return Wrap(
      children: [
        StreamBuilder<List<File>?>(
          stream: _createDeviceBloc.listImageStream,
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
          await _createDeviceBloc.pickDeviceImages();
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
