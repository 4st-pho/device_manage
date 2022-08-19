import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_device_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_image.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class DeviceManagePage extends StatefulWidget {
  const DeviceManagePage({Key? key}) : super(key: key);

  @override
  State<DeviceManagePage> createState() => _DeviceManagePageState();
}

class _DeviceManagePageState extends State<DeviceManagePage> {
  late final TextEditingController _searchController;
  late final ManageDeviceBloc _deviceManageBloc;
  @override
  void initState() {
    _searchController = TextEditingController();
    _deviceManageBloc = ManageDeviceBloc();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _deviceManageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.deviceManage),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildSearchTextField(context),
            _buildTabBar(),
          ],
        ),
      ),
    );
  }

  Expanded _buildTabBar() {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              onTap: _deviceManageBloc.onTabChange,
              indicatorColor: AppColor.white,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: AppString.userDevices),
                Tab(icon: Icon(Icons.groups), text: AppString.teamDevices),
                Tab(
                    icon: Icon(Icons.devices),
                    text: AppString.availableDevices),
              ],
            ),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTabBarContent(),
                    _buildTabBarContent(),
                    _buildTabBarContent(),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<Device>> _buildTabBarContent() {
    return StreamBuilder<List<Device>>(
        stream: _deviceManageBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Image.asset(AppImage.empty),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final device = data[index];
                return InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(
                        Routes.detailDeviceRoute,
                        arguments: device,
                      )
                      .then((_) => _deviceManageBloc.init()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.healthyStatus.name),
                      trailing: Text(device.deviceType.name),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          device.imagePaths[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  SearchTextField _buildSearchTextField(BuildContext context) {
    return SearchTextField(
      hintText: AppString.searchUserNameOrTeam,
      controller: _searchController,
      onChanged: _deviceManageBloc.onTextChange,
      onSuffixPresses: () {},
      onSubmitted: (_) {},
      isShowSuffixIcon: false,
    );
  }
}