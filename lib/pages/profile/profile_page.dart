import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/profile/widgets/profile_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: [
            if (currentUser!.role != Role.admin) _buildUserWidget(context),
            if (currentUser!.role == Role.admin) _buildAdminWidget(context)
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
        const SizedBox(height: 16),
        ProfileItem(
          text: AppString.createUser,
          icon: Icons.person_add,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.createUserRoute),
        ),
        const SizedBox(height: 16),
        ProfileItem(
          text: AppString.createDevice,
          icon: Icons.devices,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.createDeviceRoute),
        ),
      ],
    );
  }

  Column _buildUserWidget(BuildContext context) {
    return Column(
      children: [
        ProfileItem(
          text: AppString.myDevice,
          icon: Icons.my_library_books,
          onPressed: () => Navigator.of(context).pushNamed(Routes.myDevice),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
