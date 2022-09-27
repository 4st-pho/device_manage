import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';

class MyDeviceBloc {
  Future<List<Device>> getOwnerDevices(String ownerId) {
    return DeviceService().getOwnerDevices(ownerId);
  }

  void dispose() {}
}
