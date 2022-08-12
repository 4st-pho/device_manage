import 'package:flutter/cupertino.dart';

void unFocus(BuildContext context) {
  if (FocusScope.of(context).hasFocus) {
    FocusScope.of(context).unfocus();
  }
}
