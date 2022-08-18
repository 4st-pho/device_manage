import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class InitMethod {
  Future<void> getUserSameTeam() async {
    teamMember = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getUserSameTeam();
  }

  bool isContainList(Device device, List<Device> devices) {
    for (var element in devices) {
      if (element.name == device.name) {
        return true;
      }
    }
    return false;
  }

  Future<void> getAllDeviceCategory() async {
    final tempList =
        await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllDevice();
    for (var e in tempList) {
      if (!isContainList(e, deviceCategory)) {
        deviceCategory.add(e);
      }
    }
  }

  Future<void> getCurrentUser() async {
    currentUser =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance).getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  Future<void> getAllTeam() async {
    allteam = await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllTeam();
  }
}
