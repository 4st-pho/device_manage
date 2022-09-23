import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final VoidCallback onSuffixPresses;
  final IconData iconData;
  final bool isShowSuffixIcon;
  const SearchTextField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.iconData = Icons.search,
    required this.hintText,
    required this.controller,
    required this.onSuffixPresses,
    this.isShowSuffixIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          cursorColor: Colors.white,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          // autofocus: true,
          decoration: InputDecoration(
            suffixIcon: isShowSuffixIcon
                ? IconButton(
                    icon: Icon(iconData),
                    onPressed: onSuffixPresses,
                    color: AppColor.lightBlue,
                  )
                : null,
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
