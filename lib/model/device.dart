import 'dart:convert';

import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/enums/owner_type.dart';

class Device {
  String id;
  String name;
  List<String> imagePaths;
  String info;
  DeviceType deviceType;
  OwnerType ownerType;
  HealthyStatus healthyStatus;
  String? ownerId;

  DateTime? transferDate;
  DateTime manufacturingDate;
  DateTime createdAt;
  Device(
      {this.id = '',
      this.name = '',
      this.imagePaths = const [''],
      this.info = '',
      this.deviceType = DeviceType.laptop,
      this.ownerType = OwnerType.none,
      this.healthyStatus = HealthyStatus.good,
      this.ownerId,
      this.transferDate,
      DateTime? manufacturingDate,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now(),
        manufacturingDate = manufacturingDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imagePaths': imagePaths,
      'info': info,
      'deviceType': deviceType.name,
      'ownerType': ownerType.name,
      'healthyStatus': healthyStatus.name,
      'ownerId': ownerId,
      'transferDate': transferDate?.toIso8601String(),
      'manufacturingDate': manufacturingDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePaths: (map['imagePaths'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      info: map['info'] as String,
      deviceType: DeviceType.values.byName(map['deviceType']),
      ownerType: OwnerType.values.byName(map['ownerType']),
      healthyStatus: HealthyStatus.values.byName(map['healthyStatus']),
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      transferDate: map['transferDate'] != null
          ? DateTime.parse(map['transferDate'])
          : null,
      manufacturingDate: DateTime.parse(map['manufacturingDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);
}
