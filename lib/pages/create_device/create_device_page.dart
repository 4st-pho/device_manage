import 'dart:io';
import 'package:manage_devices_app/bloc/load_bloc.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:provider/provider.dart';

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
  late final CreateDeviceBloc _createDeviceBloc;
  late final LoadBloc _loadBloc;
  late final PickMultiImageBloc _pickMultiImageBloc;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _infoController = TextEditingController();
    _pickDateBloc = context.read<PickDateBloc>();
    _pickMultiImageBloc = context.read<PickMultiImageBloc>();
    _createDeviceBloc = context.read<CreateDeviceBloc>();
    _loadBloc = context.read<LoadBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
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
                    _buildLabel(AppString.healthyStatus),
                    _buildHealthyStatusDropDown(),
                    _buildLabel(AppString.deviceType),
                    _buildDeviceTypeDropDown(),
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
            stream: _loadBloc.loadStream,
            initialData: false,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: AppString.createDevice,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _loadBloc.setLoadState(true);
                          String error = '';
                          if (_pickMultiImageBloc.images == null) {
                            error += AppString.imageIsRequired;
                          }
                          if (_pickDateBloc.date == null) {
                            error += '\n${AppString.dateIsRequired}';
                          }
                          if (error.isNotEmpty) {
                            showSnackBar(
                                context: context, content: error, error: true);
                            _loadBloc.setLoadState(false);
                            return;
                          }

                          _createDeviceBloc
                              .createDevice(
                            name: _nameController.text,
                            info: _infoController.text,
                            date: _pickDateBloc.date,
                            files: _pickMultiImageBloc.images,
                          )
                              .catchError((error) {
                            showSnackBar(
                                context: context, content: error.toString());
                            _loadBloc.setLoadState(false);
                          }).then((value) {
                            showSnackBar(
                                context: context,
                                content: AppString.createSuccess);
                            Navigator.of(context).pop();
                          });
                        },
                ),
              );
            },
          ),
        ],
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
      onChanged: _createDeviceBloc.onHealthyStatusChange,
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
      onChanged: _createDeviceBloc.onDeviceTypeChange,
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

  Widget _buildPickDate(BuildContext context) {
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

  Widget _buildPickImage() {
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
