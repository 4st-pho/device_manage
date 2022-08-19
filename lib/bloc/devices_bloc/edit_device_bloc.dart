import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';

class EditDeviceBloc {
  final Device device;
  EditDeviceBloc(this.device);
  void onNameChange(String? name) {
    if (name != null || name!.isNotEmpty) {
      device.name = name;
    }
  }

  void onInfoChange(String? info) {
    if (info != null || info!.isNotEmpty) {
      device.info = info;
    }
  }

  void onDeviceTypeChange(DeviceType? deviceType) {
    device.deviceType = deviceType!;
  }

  void onHeathyStatusChange(HealthyStatus? healthyStatus) {
    device.healthyStatus = healthyStatus!;
  }

  Future<void> done(
    BuildContext context,
    GlobalKey<FormState> formKey,
    List<File>? files,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    showSnackBar(context: context, content: 'Pending');
    Navigator.of(context).pop();
    if (files != null) {
      final imagesLink =
          await StorageMethods(firebaseStorage: FirebaseStorage.instance)
              .uploadAndGetImagesLink(AppCollectionPath.image, files);
      device.imagePaths = imagesLink;
    }
    // ignore: use_build_context_synchronously
    await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
        .updateDevice(context, device.toMap());
  }

  void dispose() {}
}
