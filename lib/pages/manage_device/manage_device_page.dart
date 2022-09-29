import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_available_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_team_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_user_device_bloc.dart';
import 'package:manage_devices_app/enums/manage_device_tab.dart';
import 'package:manage_devices_app/pages/manage_available_device/manage_available_device_page.dart';
import 'package:manage_devices_app/pages/manage_team_device/manage_team_device_page.dart';
import 'package:manage_devices_app/pages/manage_user_device/manage_user_device_page.dart';
import 'package:provider/provider.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class ManageDevicePage extends StatefulWidget {
  const ManageDevicePage({Key? key}) : super(key: key);

  @override
  State<ManageDevicePage> createState() => _ManageDevicePageState();
}

class _ManageDevicePageState extends State<ManageDevicePage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final ManageDeviceBloc _manageDeviceBloc;
  late ManageDeviceTab currentTab = ManageDeviceTab.userDevices;
  final _manageDeviceTab = const [
    Tab(icon: Icon(Icons.person), text: AppString.userDevices),
    Tab(icon: Icon(Icons.groups), text: AppString.teamDevices),
    Tab(icon: Icon(Icons.devices), text: AppString.availableDevices),
  ];
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _manageDeviceBloc = context.read<ManageDeviceBloc>();
    _tabController = TabController(
        length: _manageDeviceTab.length,
        vsync: this,
        initialIndex: currentTab.index);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: MultiProvider(
        providers: [
          Provider<ManageUserDeviceBloc>(
            create: (context) => ManageUserDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
          ),
          Provider<ManageTeamDeviceBloc>(
            create: (context) => ManageTeamDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
          ),
          Provider<ManageAvailableDeviceBloc>(
            create: (context) => ManageAvailableDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
          ),
        ],
        builder: (context, _) {
          final manageUserDeviceBloc = context.read<ManageUserDeviceBloc>();
          final manageTeamDeviceBloc = context.read<ManageTeamDeviceBloc>();
          final manageAvailableDeviceBloc =
              context.read<ManageAvailableDeviceBloc>();
          return Column(
            children: [
              _buildSearchTextField(manageUserDeviceBloc, manageTeamDeviceBloc,
                  manageAvailableDeviceBloc),
              _buildContent(),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: const Text(AppString.manageDevice),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: DefaultTabController(
        length: _manageDeviceTab.length,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: _buildtabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      indicatorColor: AppColor.white,
      controller: _tabController,
      tabs: _manageDeviceTab,
      onTap: (indexTab) {
        currentTab = _manageDeviceBloc.defineTab(indexTab);
      },
    );
  }

  Widget _buildtabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      children: const [
        ManageUserDevicePage(),
        ManageTeamDevicePage(),
        ManageAvailableDevicePage(),
      ],
    );
  }

  Widget _buildSearchTextField(
      ManageUserDeviceBloc manageUserDeviceBloc,
      ManageTeamDeviceBloc manageTeamDeviceBloc,
      ManageAvailableDeviceBloc manageAvailableDeviceBloc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchTextField(
        hintText: AppString.searchNameOfUserTeamOrDevice,
        controller: _searchController,
        onSuffixPresses: () {},
        onSubmitted: (_) {},
        isShowSuffixIcon: false,
        onChanged: (value) {
          switch (currentTab) {
            case ManageDeviceTab.userDevices:
              manageUserDeviceBloc.onSearch(value);
              break;
            case ManageDeviceTab.teamDevices:
              manageTeamDeviceBloc.onSearch(value);
              break;
            case ManageDeviceTab.availableDevices:
              manageAvailableDeviceBloc.onSearch(value);
              break;
          }
          manageUserDeviceBloc.setSearchKeywork(value);
          manageTeamDeviceBloc.setSearchKeywork(value);
          manageAvailableDeviceBloc.setSearchKeywork(value);
        },
      ),
    );
  }
}
