import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/device_category.dart';

class DeviceCategoryMethod {
  final FirebaseFirestore firebaseFirestore;
  DeviceCategoryMethod({
    required this.firebaseFirestore,
  });
  Future<void> createDeviceCategory(BuildContext context, String name) async {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.deviceCategory).doc();
      final deviceCategory =
          DeviceCategory(id: doc.id, name: name, createdAt: DateTime.now());
      await doc.set(deviceCategory.toMap());
      showSnackBar(context: context, content: 'Create succes!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  Future<DeviceCategory> getDeviceCategory(String id) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.deviceCategory).doc(id);
    final value = await doc.get();
    return DeviceCategory.fromMap(value.data()!);
  }

  Future<List<DeviceCategory>> getAllDeviceCategory() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.deviceCategory);
    final value = await doc.get();
    return value.docs.map((e) => DeviceCategory.fromMap(e.data())).toList();
  }
}
