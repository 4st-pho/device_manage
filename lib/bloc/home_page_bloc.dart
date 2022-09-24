import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';

class HomePageBloc {
  Future<List<Device>> getTeamDevices() async {
    final currentUser = await SharedPreferencesMethod.getCurrentUserFromLocal();
    return DeviceService().getOwnerDevices(currentUser.teamId);
  }

  void dispose() {}
}
