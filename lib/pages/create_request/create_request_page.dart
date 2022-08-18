import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/request_bloc/create_request_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
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
  final createRequestBloc = CreateRequestBloc();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.createRequest),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
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
                  _buildLabel(AppString.errorStatus),
                  DropdownButtonFormField<ErrorStatus>(
                      isExpanded: true,
                      value: createRequestBloc.request.errorStatus,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColor.lightBlack,
                          border: OutlineInputBorder(),
                          enabledBorder: AppDecoration.outlineInputBorder,
                          focusedBorder: AppDecoration.focusOutlineInputBorder),
                      items: ErrorStatus.values
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: createRequestBloc.changeErrorStatus),
                  _buildLabel(AppString.device),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: FormValidate().selectOption,
                    decoration: AppDecoration.inputDecoration,
                    items: deviceCategory
                        .map((e) =>
                            DropdownMenuItem(value: e.id, child: Text(e.name)))
                        .toList(),
                    onChanged: createRequestBloc.changeDeviceId,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: AppString.send,
                    onPressed: () => createRequestBloc.sendData(
                      _titleController.text,
                      _contentController.text,
                      _formKey,
                      context,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
}
