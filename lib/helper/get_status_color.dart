import 'package:flutter/material.dart';
import 'package:manage_devices_app/enums/request_status.dart';

Color getStatusColor(RequestStatus requestStatus) {
  switch (requestStatus) {
    case RequestStatus.accept:
      return Colors.green;
    case RequestStatus.refuse:
      return Colors.red;
    case RequestStatus.pending:
      return Colors.blue;
    default:
      return Colors.deepPurple;
  }
}
