import 'package:manage_devices_app/bloc/profile_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/helper/show_custom_snackbar.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/pages/profile/widgets/profile_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _profileBloc;
  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
  }

  void logOut() {
    _profileBloc
        .logOut()
        .then((_) =>
            Navigator.of(context).pushReplacementNamed(Routes.authWrapper))
        .catchError((error) {
      showCustomSnackBar(
          context: context, content: error.toString(), error: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: [
            if (currentUser!.role != Role.admin) _buildUserWidget(context),
            if (currentUser.role == Role.admin) _buildAdminWidget(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        AppString.deviceManage,
        style: AppStyle.blueTitle,
      ),
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

  Widget _buildAdminWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileItem(
          text: AppString.deviceManage,
          icon: Icons.devices_sharp,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.manageDeviceRoute),
        ),
        ProfileItem(
          text: AppString.createDevice,
          icon: Icons.add_circle_outline,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.createDeviceRoute),
        ),
      ],
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return ProfileItem(
      text: AppString.myDevice,
      icon: Icons.my_library_books,
      onPressed: () => Navigator.of(context).pushNamed(Routes.myDevice),
    );
  }
}
