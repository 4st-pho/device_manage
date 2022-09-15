import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';

class CreateDeviceBloc {
  final device = Device(
    id: '',
    name: '',
    imagePaths: [],
    info: '',
    deviceType: DeviceType.headphone,
    healthyStatus: HealthyStatus.good,
    ownerId: null,
    ownerType: OwnerType.none,
    transferDate: null,
    manufacturingDate: DateTime.now(),
  );

  void onDeviceTypeChange(DeviceType? deviceType) {
    device.deviceType = deviceType!;
  }

  void onHealthyStatusChange(HealthyStatus? healthyStatus) {
    device.healthyStatus = healthyStatus!;
  }

  Future<void> createDevice({
    required GlobalKey<FormState> formKey,
    required String name,
    required String info,
    List<File>? files,
    DateTime? date,
  }) async {
    if (formKey.currentState!.validate()) {
      String error = '';
      if (files == null) {
        error += AppString.imageIsRequired;
      }
      if (date == null) {
        error += '\n${AppString.dateIsRequired}';
      }
      if (error.isNotEmpty) {}
      device.name = name.trim();
      device.info = info.trim();
      device.manufacturingDate = date!;
      final imagesLink =
          await StorageMethods(firebaseStorage: FirebaseStorage.instance)
              .uploadAndGetImagesLink(AppCollectionPath.image, files!);
      device.imagePaths = imagesLink;

      DeviceService()
          .createDevice(device);
    }
  }
}
