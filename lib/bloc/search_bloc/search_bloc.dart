import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/helper/debounce.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class SearchBloc {
  String keywork = '';
  List<String> result = [];
  List<String> data = [];

  final StreamController<List<String>> _controller =
      StreamController<List<String>>();

  Stream<List<String>> get stream => _controller.stream;
  SearchBloc() {
    init();
  }
  void init() async {
    await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllDeviceName()
        .then((value) {
      data = [...data, ...value];
    });
    await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllUserName()
        .then((value) {
      data = [...data, ...value];
    });
    await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllTeamName()
        .then((value) {
      data = [...data, ...value];
    });
    _controller.sink.add([...data].take(15).toList());
  }

  void onSubmitted(BuildContext context,
      {String? value, TextEditingController? textController}) {
    if (value != null) {
      keywork = value;
    }
    if (textController != null) {
      textController.text = keywork;
      updateResult();
    }
    Navigator.of(context)
        .pushNamed(Routes.searchResultRoute, arguments: keywork);
  }

  void onTextChange(String value) {
    keywork = value;
    Debounce().run(() {
      updateResult();
    });
  }

  void updateResult() {
    result = data
        .where((e) =>
            e.trim().toLowerCase().contains(keywork.trim().toLowerCase()))
        .take(15)
        .toList();
    _controller.sink.add(result);
  }

  void dispose() {
    _controller.close();
  }
}
