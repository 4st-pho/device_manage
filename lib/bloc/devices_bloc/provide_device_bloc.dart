import 'dart:async';

import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';

class ProviceDeviceBloc {
  String deviceId;

  String value = 'User';
  List<String> values = ['User', 'Team'];
  ProviceDeviceBloc(this.deviceId);
  bool get isChooseUser => value == values[0];
  final StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;

  void onChanged(String? value) {
    if (value != null) {
      this.value = value;
      _controller.sink.add(isChooseUser);
    }
  }

  void submit(dynamic owner) {
    if (owner == null) {
      return;
    }
    DeviceService().provideDevice(
      id: deviceId,
      ownerId: owner.id,
      ownerType: isChooseUser ? OwnerType.user : OwnerType.team,
    );
  }

  void dispose() {
    _controller.close();
  }
}
