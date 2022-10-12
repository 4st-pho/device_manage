import 'package:manage_devices_app/bloc/menu_page_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/menu/widgets/menu_item_box.dart';
import 'package:manage_devices_app/resource/route_manager.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final MenuPageBloc _profileBloc;
  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<MenuPageBloc>();
  }

  void logOut() {
    _profileBloc
        .logOut()
        .then((_) =>
            Navigator.of(context).pushReplacementNamed(Routes.authWrapper))
        .catchError((error) {
      showCustomSnackBar(
          context: context, content: error.toString(), isError: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final currentUser = context.read<AppData>().currentUser;
    if (currentUser!.role == Role.admin) {
      return _buildAdminWidget();
    }
    return _buildUserWidget();
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(AppString.devicesManagement),
      actions: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.backgroudNavigation.withOpacity(0.5)),
          // padding: const EdgeInsets.all(4.0),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logOut(),
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget _buildAdminWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuItemBox(
          text: AppString.manageDevice,
          icon: Icons.devices_sharp,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.manageDeviceRoute),
        ),
        MenuItemBox(
          text: AppString.createDevice,
          icon: Icons.add_circle_outline,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.createDeviceRoute),
        ),
      ],
    );
  }

  Widget _buildUserWidget() {
    return MenuItemBox(
      text: AppString.myDevice,
      icon: Icons.devices,
      onPressed: () => Navigator.of(context).pushNamed(Routes.myDevice),
    );
  }
}
