import 'dart:async';

import 'package:manage_devices_app/model/device.dart';

class DeleteDeviceBloc {
  final StreamController<Device?> _controller = StreamController<Device?>();
  Stream<Device?> get stream => _controller.stream;
  void onTextChange(String? text) {
    if (text != null ) {

    }
  }

  void dispose() {
    _controller.close();
  }
}
