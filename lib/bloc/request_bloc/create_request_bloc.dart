import 'dart:async';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';

class CreateRequestBloc {
  Device? avalbleDevice;
  Device? mydevice;
  bool requestNewDevice = false;
  final request = Request(
    uid: '',
    id: '',
    deviceId: '',
    title: '',
    content: '',
    requestStatus: RequestStatus.pending,
    errorStatus: ErrorStatus.none,
  );
  final StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;
  void onCheckBoxNewDevice(bool? value) {
    requestNewDevice = value ?? false;
    _controller.sink.add(requestNewDevice);
  }

  final StreamController<Device?> _availbleDeviceController =
      StreamController<Device?>.broadcast();
  Stream<Device?> get streamAvailbleDevice => _availbleDeviceController.stream;

  void onChooseAvailbleDevice(Device? device) {
    avalbleDevice = device;
    request.deviceId = avalbleDevice!.id;
    _availbleDeviceController.sink.add(avalbleDevice);
  }

  void changeErrorStatus(ErrorStatus? status) {
    request.errorStatus = status!;
  }

  void changeDeviceId(Device? deviceParam) {
    request.deviceId = deviceParam!.id;
    mydevice = deviceParam;
  }

  void sendData(String title, String content, GlobalKey<FormState> formKey,
      BuildContext context) async {
    try {
      String error = '';
      final currentUser = context.read<AppData>().currentUser;
      request.uid = currentUser!.id;
      if (!formKey.currentState!.validate()) {
        return;
      }
      if (requestNewDevice) {
        request.errorStatus = ErrorStatus.none;
        if (avalbleDevice == null) {
          error += 'Device is required';
        }
      }
      if (error.isNotEmpty) {
        showSnackBar(context: context, content: error, error: true);
        return;
      }

      if (currentUser.role == Role.leader) {
        request.requestStatus = RequestStatus.approved;
      }
      request.title = title;
      request.content = content;
      RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
          .createRequest(request, context);
      Navigator.of(context).pop();

      showSnackBar(context: context, content: 'Request send succes!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  void sendRequest() {}
  void dispose() {
    _availbleDeviceController.close();
    _controller.close();
  }
}
