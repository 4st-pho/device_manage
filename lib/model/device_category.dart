// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manage_devices_app/constants/app_image.dart';

class DeviceCategory {
  String id;
  String name;
  String imagePath;
  DateTime createdAt;
  DeviceCategory({
    required this.id,
    required this.name,
     this.imagePath = AppImage.defaultTeamImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DeviceCategory.fromMap(Map<String, dynamic> map) {
    return DeviceCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceCategory.fromJson(String source) =>
      DeviceCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}
