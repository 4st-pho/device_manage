import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_devices_app/services/clound_firestore/device_category_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class InitMethod {
  Future<void> getUserSameTeam() async {
    teamMember = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getUserSameTeam();
  }

  Future<void> getAllDeviceCategory() async {
    deviceCategory = await DeviceCategoryMethod(
            firebaseFirestore: FirebaseFirestore.instance)
        .getAllDeviceCategory();
  }

  Future<void> getCurrentUser() async {
    currentUser =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance).getUser(
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
  }
}
