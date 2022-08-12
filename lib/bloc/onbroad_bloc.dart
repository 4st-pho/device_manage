import 'dart:async';

import 'package:flutter/material.dart';
import '../constants/app_image.dart';
import '../constants/app_strings.dart';
import '../helper/shared_preferences.dart';
import '../pages/login/login_page.dart';
import '../pages/onbroad/widgets/onbroad_item.dart';

class OnbroadBloc {
  int _pageIndex = 0;
  final List<OnroadItem> listOnbroadItem = const [
    OnroadItem(
        image: AppImage.onbroad1,
        title: AppString.onbroadTitle1,
        content: AppString.onbroadContent1),
    OnroadItem(
        image: AppImage.onbroad2,
        title: AppString.onbroadTitle2,
        content: AppString.onbroadContent1),
    OnroadItem(
        image: AppImage.onbroad3,
        title: AppString.onbroadTitle3,
        content: AppString.onbroadContent1),
  ];
  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;
  bool get isFinish => _pageIndex == listOnbroadItem.length - 1;
  void selectPage(
      {required PageController pageController, required BuildContext context}) {
    int nextPageIndex = _pageIndex + 1;
    if (nextPageIndex >= listOnbroadItem.length) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      SharedPreferencesMethod()
          .setBool(key: AppString.skipOnbroading, value: true);
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
