import 'package:manage_devices_app/constants/app_strings.dart';

class FormValidate {
  String? titleValidate(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 6) {
      return AppString.lessThan6;
    }
    if (value.length > 150) {
      return AppString.exceed150;
    }
    return null;
  }


  String? contentValidate(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 10) {
      return AppString.lessThan10;
    }
    if (value.length > 3000) {
      return AppString.exceed3000;
    }
    return null;
  }

  String? selectOption(dynamic value) {
    if (value == null) {
      return AppString.selectOneOption;
    }
    return null;
  }

  String? passworkValidate(String? value) {
    value = value ?? '';
    if ((value).isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 6) {
      return AppString.lessThan6;
    }
    if (value.length > 30) {
      return AppString.exceed30;
    }
    return null;
  }

  String? emailValidate(String? value) {
    value = value ?? '';
    if ((value).isEmpty) {
      return AppString.enterSomeText;
    }
    if (value.length < 6) {
      return AppString.lessThan6;
    }
    if (value.length > 30) {
      return AppString.exceed30;
    }
    if (!value.contains('@')) {
      return AppString.emailRequired;
    }
    return null;
  }
}
