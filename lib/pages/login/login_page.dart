import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/login_bloc.dart';
import 'package:manage_devices_app/constants/app_icon.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/pages/login/widgets/email_text_form_field.dart';
import 'package:manage_devices_app/pages/login/widgets/password_text_form_field.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginGogolePageState();
}

class _LoginGogolePageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final LoginBloc _loginBloc;
  final _formKey = GlobalKey<FormState>();
  void login() {
    if (_formKey.currentState!.validate()) {
      _loginBloc
          .login(_emailController.text, _passwordController.text)
          .catchError((e) {
        showCustomSnackBar(
            context: context, content: e.toString(), isError: true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = context.read<LoginBloc>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLogo(size),
            _buildForm(),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 60),
      child: StreamBuilder<bool>(
        stream: _loginBloc.loadStream,
        initialData: false,
        builder: (context, snapshot) {
          final isLoading = snapshot.requireData;
          return CustomButton(
            text: AppString.login,
            onPressed: isLoading ? null : () => login(),
          );
        },
      ),
    );
  }

  Widget _buildLogo(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Image.asset(AppIcon.logo, width: size.width / 2),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailTextFormField(textEditingController: _emailController),
          const SizedBox(height: 16),
          PasswordTextFormField(
            passwordController: _passwordController,
            onFieldSubmitted: (_) => login(),
          ),
        ],
      ),
    );
  }
}
