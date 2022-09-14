import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
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
    GlobalKey<FormState> formKey,
    List<File>? files,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (files != null) {
      final imagesLink =
          await StorageMethods(firebaseStorage: FirebaseStorage.instance)
              .uploadAndGetImagesLink(AppCollectionPath.image, files);
      device.imagePaths = imagesLink;
    }
    // ignore: use_build_context_synchronously
    await DeviceService()
        .updateDevice(device.toMap());
  }

  void dispose() {}
}
