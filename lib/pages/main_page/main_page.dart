import 'package:manage_devices_app/bloc/dashbroad_bloc.dart';
import 'package:manage_devices_app/bloc/home_page_bloc.dart';
import 'package:manage_devices_app/bloc/menu_page_bloc.dart';
import 'package:manage_devices_app/bloc/request_bloc/request_bloc.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/pages/admin/dashboard_page.dart';
import 'package:manage_devices_app/pages/menu/menu_page.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:manage_devices_app/bloc/main_page_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/home/home_page.dart';
import 'package:manage_devices_app/pages/request/request_page.dart';
import 'package:manage_devices_app/pages/search/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final MainPageBloc _mainPageBloc;
  @override
  void initState() {
    super.initState();
    _mainPageBloc = context.read<MainPageBloc>();
  }

  @override
  void dispose() {
    _mainPageBloc.dispose();
    super.dispose();
  }

  List<Widget> pages(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return [
      currentUser!.role == Role.admin
          ? Provider<DashbroadBloc>(
              create: (context) => DashbroadBloc(),
              child: const DashboardPage(),
              dispose: (context, prov) => prov.dispose(),
            )
          : Provider<HomePageBloc>(
              create: (context) => HomePageBloc(),
              dispose: (_, prov) => prov.dispose(),
              child: const HomePage(),
            ),
      Provider<SearchBloc>(
        create: (context) => SearchBloc(),
        dispose: (_, prov) => prov.dispose(),
        child: const SearchPage(),
      ),
      Provider<RequestBloc>(
        create: (context) => RequestBloc(),
        dispose: (_, prov) => prov.dispose(),
        child: const RequestPage(),
      ),
      Provider<MenuPageBloc>(
        create: (context) => MenuPageBloc(),
        dispose: (_, prov) => prov.dispose(),
        child: const MenuPage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: StreamBuilder<int>(
        stream: _mainPageBloc.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return pages(context)[snapshot.data!];
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
              icon: Icons.menu,
              text: AppString.menu,
            ),
          ],
        ),
      ),
    );
  }
}
