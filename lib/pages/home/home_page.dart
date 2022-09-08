import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/device_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildTitle(AppString.teamDevice),
          _buildListTeamDevice(context),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildListTeamDevice(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Device>>(
        initialData: const [],
        future: DeviceService()
            .getOwnerDevices(context.read<AppData>().currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final myDevice = snapshot.data as List<Device>;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              primary: false,
              itemCount: myDevice.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DeviceCard(device: myDevice[index]),
                );
              },
            );
          }
          if (snapshot.hasError) {
            final String error = snapshot.error.toString();
            return Center(child: Text(error));
          }
          return ShimmerList.deviceCard;
        },
      ),
    );
  }

  SliverToBoxAdapter _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4, color: AppColor.dartBlue),
              ),
            ),
            child: Text(title, style: AppStyle.blueTitle),
          ),
        ],
      ),
    );
  }
}
