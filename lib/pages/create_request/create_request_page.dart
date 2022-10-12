import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/pages/create_request/widgets/select_device_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/request_bloc/create_request_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/form_validate.dart';
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
  late final CreateRequestBloc _createRequestBloc;
  final _formKey = GlobalKey<FormState>();

  Future<void> sendRequest() async {
    if (_formKey.currentState!.validate()) {
      _createRequestBloc.sendRequest().then((value) {
        showCustomSnackBar(context: context, content: AppString.sendSucces);
        Navigator.of(context).pop();
      }).catchError(
        (error) {
          showCustomSnackBar(
              context: context, content: error.toString(), isError: true);
        },
      );
    }
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _createRequestBloc = context.read<CreateRequestBloc>();
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildForm(),
          ),
          _buildSendRequestButton(context),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          CustomTextFormField(
            laber: AppString.title,
            controller: _titleController,
            type: TextInputType.multiline,
            validator: FormValidate().titleValidate,
            onChanged: _createRequestBloc.onTitleChange,
          ),
          CustomTextFormField(
            laber: AppString.content,
            controller: _contentController,
            type: TextInputType.multiline,
            validator: FormValidate().contentValidate,
            onChanged: _createRequestBloc.onContentChange,
          ),
          const SelectDeviceWidget(),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.createRequest),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
    );
  }

  Widget _buildSendRequestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<bool>(
        stream: _createRequestBloc.loadStream,
        initialData: false,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;
          return CustomButton(
            text: AppString.send,
            onPressed: isLoading ? null : () => sendRequest(),
          );
        },
      ),
    );
  }
}
