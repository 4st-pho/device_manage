import 'dart:convert';

import 'package:manage_devices_app/constants/app_image.dart';
import 'package:manage_devices_app/enums/role.dart';

class User {
  String id;
  String avatar;
  String name;
  int age;
  String address;
  String teamId;
  Role role;
  DateTime startWork;
  DateTime createdAt;
  User({
    required this.id,
    this.avatar = AppImage.defaultUserImage,
    required this.name,
    required this.age,
    required this.address,
    required this.teamId,
    required this.role,
    required this.startWork,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'name': name,
      'age': age,
      'address': address,
      'teamId': teamId,
      'role': role.name,
      'startWork': startWork.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      address: map['address'] as String,
      teamId: map['teamId'] as String,
      role: Role.values.byName(map['role']),
      startWork: DateTime.parse(map['startWork']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
