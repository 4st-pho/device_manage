import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/form_validate.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  const EmailTextFormField({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(20),
        prefixIcon: Icon(Icons.email),
        filled: true,
        fillColor: AppColor.lightBlack,
        hintText: AppString.email,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.lightBlack),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: FormValidate().emailValidate,
    );
  }
}
