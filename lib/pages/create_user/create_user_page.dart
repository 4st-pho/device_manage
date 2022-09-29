import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/user_bloc/create_user_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_image.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
import 'package:manage_devices_app/helper/show_date_picker.dart';
import 'package:manage_devices_app/model/team.dart';
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
  late final CreateUserBloc _createUserBloc;
  DateTime? startWork;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _createUserBloc = CreateUserBloc();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _createUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SingleChildScrollView(
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
            _buildLabel(AppString.role),
            DropdownButtonFormField<Role>(
              isExpanded: true,
              validator: FormValidate().selectOption,
              decoration: AppDecoration.inputDecoration,
              items: Role.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (_) {},
            ),
            _buildLabel(AppString.team),
            StreamBuilder<List<Team>>(
                stream: _createUserBloc.streamListTeam,
                builder: (context, snapshot) {
                  final List<Team> allTeam = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: FormValidate().selectOption,
                    decoration: AppDecoration.inputDecoration,
                    items: allTeam
                        .map((e) =>
                            DropdownMenuItem(value: e.id, child: Text(e.name)))
                        .toList(),
                    onChanged: (_) {},
                  );
                }),
            _buildLabel(AppString.dateStartWork),
            Row(
              children: [
                Expanded(
                  child: Text(startWork == null ? '' : startWork.toString()),
                ),
                Expanded(
                  child: CustomButton(
                    text: AppString.chooseDate,
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
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: const Text(AppString.createUser),
      centerTitle: true,
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label),
    );
  }
}
