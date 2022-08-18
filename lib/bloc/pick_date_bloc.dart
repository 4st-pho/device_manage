import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/helper/show_date_picker.dart';

class PickDateBloc {
  DateTime? date;

  final StreamController<DateTime?> _controller = StreamController<DateTime?>();
  Stream<DateTime?> get stream => _controller.stream;
  Future<void> pickTime(BuildContext context) async {
    date = await showDatePickerCustom(context, initDate: date);
    if (date != null) {
      _controller.sink.add(date);
    }
  }

  void dispose() {
    _controller.close();
  }
}
