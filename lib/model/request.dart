import 'dart:convert';

import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/request_status.dart';

class Request {
  String id;
  String ownerId;
  String deviceId;
  String title;
  String content;
  ErrorType errorType;
  RequestStatus requestStatus;
  DateTime createdAt;
  OwnerType ownerType;
  Request({
    this.id = '',
    this.ownerId = '',
    this.deviceId = '',
    this.title = '',
    this.content = '',
    this.errorType = ErrorType.software,
    this.requestStatus = RequestStatus.pending,
    this.ownerType = OwnerType.none,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'deviceId': deviceId,
      'title': title,
      'content': content,
      'errorType': errorType.name,
      'requestStatus': requestStatus.name,
      'ownerType': ownerType.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'] as String,
      ownerId: (map['ownerId']??'') as String,
      deviceId: map['deviceId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      errorType: ErrorType.values.byName(map['errorType']),
      requestStatus: RequestStatus.values.byName(map['requestStatus']),
      ownerType: OwnerType.values.byName(map['ownerType']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Request(id: $id,  deviceId: $deviceId, title: $title, content: $content, errorType: $errorType, status: $requestStatus)';
  }
}
