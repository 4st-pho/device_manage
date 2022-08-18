import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debounce {
  final int milliseconds;
  Debounce({ this.milliseconds = 1000});
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer?.cancel();
}
