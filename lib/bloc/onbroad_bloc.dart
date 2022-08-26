import 'dart:async';

import 'package:flutter/material.dart';
import '../helper/shared_preferences.dart';

class OnbroadBloc {
  int _pageIndex = 0;

  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;
  bool isFinish(int listLength) => _pageIndex == listLength - 1;
  void selectPage(
      {required PageController pageController, required int listLength}) {
    int nextPageIndex = _pageIndex + 1;
    if (nextPageIndex >= listLength) {
      SharedPreferencesMethod.saveSkipOnbroading();
      return;
    }
    _pageIndex++;
    pageController.animateToPage(_pageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void onPageChanged(int currentIndex) {
    _pageIndex = currentIndex;
    _controller.sink.add(_pageIndex);
  }

  void dispose() {
    _controller.close();
  }
}
