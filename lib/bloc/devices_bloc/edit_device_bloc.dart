import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';

class EditDeviceBloc {
  Future<void> done( List<File>? files, Device device) async {
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
