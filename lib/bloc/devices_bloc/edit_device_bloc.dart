import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class EditDeviceBloc {
  final ImagePicker _picker = ImagePicker();

  /// set loading when click button submid data
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  /// pick device image
  final _pickDeviceImageController = BehaviorSubject<List<File>?>.seeded(null);
  Stream<List<File>?> get listImageStream => _pickDeviceImageController.stream;

  /// get data from behaviorSubject
  bool get isLoading => _loadController.value;
  List<File>? get deviceImageFiles => _pickDeviceImageController.value;

  Future<void> pickDeviceImages() async {
    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null) {
      final tempImageFiles = files.map((e) => File(e.path)).toList();
      _pickDeviceImageController.sink.add(tempImageFiles);
    }
  }

  void toggleState() {
    _loadController.add(!isLoading);
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<void> updateDevice(Device device) async {
    try {
      setLoadState(true);
      if (deviceImageFiles != null) {
        final imagesLink = await StorageService()
            .uploadAndGetImagesLink(AppCollectionPath.image, deviceImageFiles!);
        device.imagePaths = imagesLink;
      }
      await DeviceService().updateDevice(device.toMap());
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _loadController.close();
    _pickDeviceImageController.close();
  }
}