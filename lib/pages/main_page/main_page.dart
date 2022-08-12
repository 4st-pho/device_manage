import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:manage_devices_app/bloc/main_page_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _mainPageBloc = MainPageBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: StreamBuilder<int>(
        stream: _mainPageBloc.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return _mainPageBloc.pages[snapshot.data!];
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColor.backgroudNavigation,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: GNav(
          padding: const EdgeInsets.all(16),
          tabBackgroundColor: AppColor.background,
          // backgroundColor: Colors.deepPurpleAccent,
          color: Colors.grey,
          activeColor: Colors.blue,
          gap: 8,
          onTabChange: _mainPageBloc.onPageChange,
          tabs: const [
            GButton(
              icon: Icons.dashboard,
              text: AppString.dashboard,
            ),
            GButton(
              icon: Icons.search,
              text: AppString.search,
            ),
            GButton(
              icon: Icons.send,
              text: AppString.request,
            ),
            GButton(
              icon: Icons.settings,
              text: AppString.profile,
            ),
          ],
        ),
      ),
    );
  }
}
