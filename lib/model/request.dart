import 'dart:convert';

import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/request_status.dart';

class Request {
  String id;
  String uid;
  String deviceId;
  String title;
  String content;
  ErrorStatus errorStatus;
  RequestStatus requestStatus;
  DateTime createdAt;
  Request(
      {required this.id,
      required this.uid,
      required this.deviceId,
      required this.title,
      required this.content,
      required this.errorStatus,
      required this.requestStatus,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'deviceId': deviceId,
      'title': title,
      'content': content,
      'errorStatus': errorStatus.name,
      'requestStatus': requestStatus.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'] as String,
      uid: map['uid'] as String,
      deviceId: map['deviceId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      errorStatus: ErrorStatus.values.byName(map['errorStatus']),
      requestStatus: RequestStatus.values.byName(map['requestStatus']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Request(id: $id,  deviceId: $deviceId, title: $title, content: $content, errorStatus: $errorStatus, status: $requestStatus)';
  }
}
