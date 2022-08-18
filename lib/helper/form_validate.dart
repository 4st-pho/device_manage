import 'package:manage_devices_app/constants/app_strings.dart';

class FormValidate {
  String? titleValidate(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 10) {
      return AppString.lessThan10;
    }
    if (value.length > 100) {
      return AppString.exceed100;
    }
    return null;
  }

  String? numberValidate(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.enterValue;
    }
    if (int.parse(value) <= 0 || int.parse(value) > 200) {
      return AppString.enterValue;
    }
    return null;
  }

  String? contentValidate(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 20) {
      return AppString.lessThan20;
    }
    if (value.length > 1000) {
      return AppString.exceed1000;
    }
    return null;
  }

  String? selectOption(dynamic value) {
    if (value == null) {
      return AppString.selectOneOption;
    }
    return null;
  }
}
