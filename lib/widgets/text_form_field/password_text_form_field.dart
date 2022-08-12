import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/switch_true_false_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    Key? key,
    required this.passwordController,
    required this.onFieldSubmitted,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController passwordController;
  final FocusNode? focusNode;
  final Function(String? value) onFieldSubmitted;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  final _showHidePasswod = SwitchTrueFalseBloc();
  @override
  void dispose() {
    super.dispose();
    _showHidePasswod.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _showHidePasswod.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isShow = snapshot.data!;
        return TextFormField(
          focusNode: widget.focusNode,
          controller: widget.passwordController,
          keyboardType: TextInputType.visiblePassword,
          textAlignVertical: TextAlignVertical.center,
          obscureText: !isShow,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: InkWell(
              onTap: _showHidePasswod.toggleState,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isShow ? Icons.visibility : Icons.visibility_off_rounded,
                ),
              ),
            ),
            filled: true,
            fillColor: AppColor.lightBlack,
            hintText: AppString.password,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.lightBlack),
            ),
          ),
          onFieldSubmitted: widget.onFieldSubmitted,
        );
      },
    );
  }
}
