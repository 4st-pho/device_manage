import 'package:manage_devices_app/bloc/load_bloc.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
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
  late final LoadBloc _loadBloc;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadBloc = LoadBloc();
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
      appBar: AppBar(
        title: const Text(AppString.createRequest),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        laber: AppString.title,
                        controller: _titleController,
                        type: TextInputType.multiline,
                        validator: FormValidate().titleValidate,
                      ),
                      CustomTextFormField(
                        laber: AppString.content,
                        controller: _contentController,
                        type: TextInputType.multiline,
                        validator: FormValidate().contentValidate,
                      ),
                      const SelectDeviceWidget(),
                      const SizedBox(height: 40),
                    ]),
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<bool>(
        stream: _loadBloc.loadStream,
        initialData: false,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;
          return CustomButton(
            text: AppString.send,
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _loadBloc.setLoadState(true);
                      if (_createRequestBloc.isRequestNewDevice &&
                          _createRequestBloc.avalbleDevice == null) {
                        showSnackBar(
                          context: context,
                          content: AppString.selectAvailbleDevice,
                          error: true,
                        );
                        _loadBloc.setLoadState(false);
                        return;
                      }
                      _createRequestBloc
                          .sendRequest(
                              _titleController.text, _contentController.text)
                          .then((value) {
                        showSnackBar(
                            context: context, content: AppString.createSuccess);
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        _loadBloc.setLoadState(false);
                        showSnackBar(
                            context: context,
                            content: error.toString(),
                            error: true);
                      });
                    }
                  },
          );
        },
      ),
    );
  }
}
