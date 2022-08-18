import 'dart:async';

import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/admin/dashboard_page.dart';
import 'package:manage_devices_app/pages/profile/profile_page.dart';
import 'package:manage_devices_app/pages/search/search_page.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

import '../pages/home_page.dart';
import '../pages/request/request_page.dart';

class MainPageBloc {
  final pages = [
    currentUser!.role == Role.admin ?   const DashboardPage(): const HomePage(),
    const SearchPage(),
    const RequestPage(),
    const ProfilePage()
  ];
  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;

  void onPageChange(int index) {
    _controller.sink.add(index);
  }

  void dispose() {
    _controller.close();
  }
}
