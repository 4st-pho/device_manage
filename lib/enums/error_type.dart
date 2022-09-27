import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';

enum ErrorType { noError, software, hardware }

extension ErrorTypeExtension on ErrorType {
  Color get getColor {
    switch (this) {
      case ErrorType.noError:
        return const Color(0xff0293ee);
      case ErrorType.software:
        return const Color(0xff845bef);
      case ErrorType.hardware:
        return const Color.fromARGB(255, 242, 131, 34);
      default:
        return Colors.transparent;
    }
  }

  String get getAlias {
    switch (this) {
      case ErrorType.noError:
        return AppString.newDevice;
      case ErrorType.software:
        return AppString.software;
      case ErrorType.hardware:
        return AppString.hardware;
      default:
        return '';
    }
  }
}
