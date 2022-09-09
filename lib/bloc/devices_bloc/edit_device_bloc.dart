import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_method.dart';
import 'package:rxdart/rxdart.dart';

class EditDeviceBloc {
  final ImagePicker _picker = ImagePicker();

  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  final _pickImageController = BehaviorSubject<List<File>?>.seeded(null);
  Stream<List<File>?> get listImageStream => _pickImageController.stream;

  bool get isLoading => _loadController.value;
  List<File>? get imageFiles => _pickImageController.value;

  Future<void> pickImages() async {
    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null) {
      final tempImageFiles = files.map((e) => File(e.path)).toList();
      _pickImageController.sink.add(tempImageFiles);
    }
  }

  void toggleState() {
    _loadController.add(!isLoading);
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<void> done(Device device) async {
    setLoadState(true);
    if (imageFiles != null) {
      final imagesLink =
          await StorageMethods(firebaseStorage: FirebaseStorage.instance)
              .uploadAndGetImagesLink(AppCollectionPath.image, imageFiles!)
              .catchError((error) {
        setLoadState(false);
        throw error;
      });
      device.imagePaths = imagesLink;
    }
    await DeviceService().updateDevice(device.toMap()).catchError((error) {
      setLoadState(false);
      throw error;
    });
  }

  void dispose() {
    _loadController.close();
    _pickImageController.close();
  }
}
