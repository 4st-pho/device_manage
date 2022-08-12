import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  const SearchTextField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    required this.hintText,
    required this.controller,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          textInputAction: type == TextInputType.multiline
              ? TextInputAction.newline
              : TextInputAction.next,
          keyboardType: type,
          cursorColor: Colors.white,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => onSubmitted,
              color: AppColor.lightBlue,
            ),
            filled: true,
            fillColor: AppColor.lightBlack,
            hintText: hintText.toLowerCase(),
            border: const OutlineInputBorder(),
            focusedBorder: AppDecoration.focusOutlineInputBorder,
            // disabledBorder: AppDecoration.outlineInputBorder,
            enabledBorder: AppDecoration.outlineInputBorder,
            errorBorder: AppDecoration.errorOutlineInputBorder,
            focusedErrorBorder: AppDecoration.focusOutlineInputBorder,
          ),
        ),
      ],
    );
  }
}
