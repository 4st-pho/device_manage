import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_icon.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/services/clound_firestore/auth_service.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/text_form_field/email_text_form_field.dart';
import 'package:manage_devices_app/widgets/text_form_field/password_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginGogolePageState();
}

class _LoginGogolePageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset(AppIcon.logo, width: size.width / 2),
              const SizedBox(height: 100),
              _buildForm(),
              const SizedBox(height: 40),
              CustomButton(
                text: AppString.login,
                onPressed: () async{
                 await AuthService(firebaseAuth: FirebaseAuth.instance)
                      .signinWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context,
                  );
                },
              ),
              const SizedBox(height: 40),
              // CustomRichText(
              //   firstText: AppString.dontHaveAnAccount,
              //   lastText: AppString.signup,
              //   onTap: () {},
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailTextFormField(textEditingController: _emailController),
          const SizedBox(height: 16),
          PasswordTextFormField(
            passwordController: _passwordController,
            onFieldSubmitted: (_) {},
          ),
        ],
      ),
    );
  }
}
