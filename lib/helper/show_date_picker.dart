import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerCustom(BuildContext context,
    {DateTime? initDate}) {
  return showDatePicker(
    context: context,
    initialDate: initDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    // helpText: 'Select booking date', // Can be used as title
    cancelText: 'Cancel',
    confirmText: 'Choose',
  );
}
