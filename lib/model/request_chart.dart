// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:manage_devices_app/enums/error_type.dart';

class RequestChart {
  final String alias;
  final ErrorType errorType;
  final Color color;
  RequestChart(
      {this.alias = '',
      this.errorType = ErrorType.noError,
      this.color = Colors.blue});
}
