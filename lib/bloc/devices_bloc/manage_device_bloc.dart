import 'package:manage_devices_app/enums/manage_device_tab.dart';

class ManageDeviceBloc {
  ManageDeviceTab defineTab(index) {
    switch (index) {
      case 0:
        return ManageDeviceTab.userDevices;
      case 1:
        return ManageDeviceTab.teamDevices;
      case 2:
        return ManageDeviceTab.availableDevices;
      default:
        return ManageDeviceTab.userDevices;
    }
  }

  void dispose() {}
}
