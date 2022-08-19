import 'dart:async';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/admin/dashboard_page.dart';
import 'package:manage_devices_app/pages/profile/profile_page.dart';
import 'package:manage_devices_app/pages/search/search_page.dart';

import '../pages/home_page.dart';
import '../pages/request/request_page.dart';

class MainPageBloc {
  List<Widget> pages(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return [
      currentUser!.role == Role.admin
          ? const DashboardPage()
          : const HomePage(),
      const SearchPage(),
      const RequestPage(),
      const ProfilePage()
    ];
  }

  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;

  void onPageChange(int index) {
    _controller.sink.add(index);
  }

  void dispose() {
    _controller.close();
  }
}
