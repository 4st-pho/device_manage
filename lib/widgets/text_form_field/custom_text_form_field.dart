import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class CustomTextFormField extends StatelessWidget {
  final String laber;
  final TextInputType type;
  final bool showLabel;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  final TextEditingController controller;
  const CustomTextFormField({
    Key? key,
    required this.laber,
    required this.controller,
    required this.type,
    this.showLabel = true,
    this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(laber),
          ),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: type == TextInputType.multiline
              ? TextInputAction.newline
              : TextInputAction.next,
          keyboardType: type,
          minLines: 1,
          maxLines: type == TextInputType.multiline ? 10 : 1,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.lightBlack,
            hintText: 'Input for ${laber.toLowerCase()}',
            border: const OutlineInputBorder(),
            focusedBorder: AppDecoration.focusOutlineInputBorder,
            // disabledBorder: AppDecoration.outlineInputBorder,
            enabledBorder: AppDecoration.outlineInputBorder,
            errorBorder: AppDecoration.errorOutlineInputBorder,
            focusedErrorBorder: AppDecoration.focusOutlineInputBorder,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
