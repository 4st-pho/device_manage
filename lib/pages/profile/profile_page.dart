import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/profile/widgets/profile_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: [
            if (currentUser!.role != Role.admin) _buildUserWidget(context),
            if (currentUser.role == Role.admin) _buildAdminWidget(context)
          ],
        ),
      ),
    );
  }

  Column _buildAdminWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileItem(
          text: AppString.deviceManage,
          icon: Icons.replay_circle_filled_sharp,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.manageDeviceRoute),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ProfileItem(
            text: AppString.createUser,
            icon: Icons.person_add,
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.createUserRoute),
          ),
        ),
        ProfileItem(
          text: AppString.createDevice,
          icon: Icons.devices,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.createDeviceRoute),
        ),
      ],
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ProfileItem(
        text: AppString.myDevice,
        icon: Icons.my_library_books,
        onPressed: () => Navigator.of(context).pushNamed(Routes.myDevice),
      ),
    );
  }
}
