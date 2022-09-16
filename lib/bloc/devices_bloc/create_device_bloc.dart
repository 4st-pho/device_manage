import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/firebase_storage/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class CreateDeviceBloc {
  final device = Device();
  final ImagePicker _picker = ImagePicker();

  /// set loading when click button handle data
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;

  /// pick device images
  final _pickDeviceImageController = BehaviorSubject<List<File>?>.seeded(null);
  Stream<List<File>?> get listImageStream => _pickDeviceImageController.stream;

  ///pick date time
  final _pickDateController = BehaviorSubject<DateTime?>.seeded(null);
  Stream<DateTime?> get datePickerStream => _pickDateController.stream;

  /// get value from behavierSubject
  bool get isLoading => _loadController.value;
  List<File>? get deviceImageFiles => _pickDeviceImageController.value;
  DateTime? get datePicked => _pickDateController.value;

  void pickDate(DateTime? date) {
    if (date != null) {
      _pickDateController.sink.add(date);
    }
  }

  Future<void> pickDeviceImages() async {
    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null) {
      final tempImageFiles = files.map((e) => File(e.path)).toList();
      _pickDeviceImageController.sink.add(tempImageFiles);
    }
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  void onNameChange(String? name) {
    if (name != null) {
      device.name = name.trim();
    }
  }

  void onInfoChange(String? info) {
    if (info != null) {
      device.info = info.trim();
    }
  }

  void onDeviceTypeChange(DeviceType? deviceType) {
    device.deviceType = deviceType!;
  }

  void onHealthyStatusChange(HealthyStatus? healthyStatus) {
    device.healthyStatus = healthyStatus!;
  }

  Future<void> createDevice() async {
    try {
      setLoadState(true);
      if (datePicked == null || deviceImageFiles == null) {
        throw 'Date or images is not empty!';
      }
      device.manufacturingDate = datePicked!;
      final imagesLink = await StorageService()
          .uploadAndGetImagesLink(AppCollectionPath.image, deviceImageFiles!);
      device.imagePaths = imagesLink;
      DeviceService().createDevice(device);
    } catch (error) {
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
