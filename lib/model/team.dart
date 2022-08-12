import 'dart:convert';

import 'package:manage_devices_app/constants/app_image.dart';

class Team {
  String id;
  String name;
  String imagePath;
  DateTime createdAt;
  Team(
      {required this.id,
      required this.name,
      this.imagePath = AppImage.defaultTeamImage,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) =>
      Team.fromMap(json.decode(source) as Map<String, dynamic>);
}
