import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/empty_list.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/device_card.dart';

class MyDevicePage extends StatelessWidget {
  const MyDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.myDevice),
        centerTitle: true,
      ),
      body: _buildListMyDevice(context),
    );
  }

  Widget _buildListMyDevice(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return FutureBuilder<List<Device>>(
      future: DeviceService().getOwnerDevices(currentUser!.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userOrderDevices = snapshot.data as List<Device>;
          if (userOrderDevices.isEmpty) return const EmptyList();
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            primary: false,
            itemCount: userOrderDevices.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DeviceCard(device: userOrderDevices[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return ShimmerList.deviceCard;
        }
      },
    );
  }
}
