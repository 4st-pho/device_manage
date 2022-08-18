import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class CreateRequestBloc {
  final request = Request(
      uid: currentUser!.id,
      id: '',
      deviceId: '',
      title: '',
      content: '',
      requestStatus: RequestStatus.pending,
      errorStatus: ErrorStatus.none);
  final StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;

  void changeErrorStatus(ErrorStatus? status) {
    request.errorStatus = status!;
  }

  void changeDeviceId(String? id) {
    request.deviceId = id!;
  }

  void sendData(String title, String content, GlobalKey<FormState> formKey,
      BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (currentUser!.role == Role.leader) {
      request.requestStatus = RequestStatus.approved;
    }
    request.title = title;
    request.content = content;
    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
        .createRequest(request, context);
    Navigator.of(context).pop();
  }

  void sendRequest() {}
  void dispose() {
    _controller.close();
  }
}
