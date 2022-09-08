import 'dart:io';
import 'package:manage_devices_app/bloc/load_bloc.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:provider/provider.dart';

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
  late final LoadBloc _loadBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _infoController = TextEditingController(text: widget.device.info);
    _pickMultiImageBloc = context.read<PickMultiImageBloc>();
    _editDeviceBloc = context.read<EditDeviceBloc>();
    _loadBloc = context.read<LoadBloc>();
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
      appBar: AppBar(
        title: const Text(AppString.editDevice),
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
                      onChanged: (name) {
                        if (name != null) {
                          widget.device.name = name.trim();
                        }
                      },
                    ),
                    CustomTextFormField(
                      laber: AppString.info,
                      controller: _infoController,
                      type: TextInputType.multiline,
                      validator: FormValidate().contentValidate,
                      onChanged: (info) {
                        if (info != null) {
                          widget.device.info = info.trim();
                        }
                      },
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
            child: StreamBuilder<bool>(
                stream: _loadBloc.loadStream,
                initialData: false,
                builder: (context, snapshot) {
                  final isLoading = snapshot.data ?? false;
                  return CustomButton(
                      text: AppString.done,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _loadBloc.setLoadState(true);
                              _editDeviceBloc
                                  .done(
                                      _pickMultiImageBloc.images, widget.device)
                                  .catchError((error) {
                                showCustomSnackBar(context: context, content: error);
                                _loadBloc.setLoadState(false);
                              }).then((value) {
                                showCustomSnackBar(
                                    context: context,
                                    content: AppString.updateSuccess);
                                Navigator.of(context).pop();
                              });
                            });
                }),
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
          onChanged: (devicetype) {
            if (devicetype != null) {
              widget.device.deviceType = devicetype;
            }
          },
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
          onChanged: (healthyStatus) {
            if (healthyStatus != null) {
              widget.device.healthyStatus = healthyStatus;
            }
          },
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
