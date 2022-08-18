import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_image.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/helper/show_date_picker.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_form_field/custom_text_form_field.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _ageController;
  DateTime? startWork;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.createUser,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => unFocus(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 64,
                  child: Image.network(AppImage.defaultUserImage),
                ),
              ),
              CustomTextFormField(
                laber: AppString.email,
                controller: _emailController,
                type: TextInputType.text,
                validator: FormValidate().titleValidate,
              ),
              CustomTextFormField(
                laber: AppString.password,
                controller: _passwordController,
                type: TextInputType.text,
                validator: FormValidate().titleValidate,
              ),
              CustomTextFormField(
                laber: AppString.name,
                controller: _nameController,
                type: TextInputType.text,
                validator: FormValidate().titleValidate,
              ),
              CustomTextFormField(
                laber: AppString.address,
                controller: _addressController,
                type: TextInputType.text,
                validator: FormValidate().titleValidate,
              ),
              CustomTextFormField(
                laber: AppString.age,
                controller: _ageController,
                type: TextInputType.number,
                validator: FormValidate().numberValidate,
              ),
              _buildLabel('Role'),
              DropdownButtonFormField<Role>(
                isExpanded: true,
                validator: FormValidate().selectOption,
                decoration: AppDecoration.inputDecoration,
                items: Role.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (_) {},
              ),
              _buildLabel('Team'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                validator: FormValidate().selectOption,
                decoration: AppDecoration.inputDecoration,
                items: allteam
                    .map((e) =>
                        DropdownMenuItem(value: e.id, child: Text(e.name)))
                    .toList(),
                onChanged: (_) {},
              ),
              _buildLabel('Date start work'),
              Row(
                children: [
                  Expanded(
                    child: Text(startWork == null ? '' : startWork.toString()),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'Choose date',
                      onPressed: () async {
                        startWork = await showDatePickerCustom(context);
                      },
                    ),
                  )
                ],
              )
            ],
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
}
