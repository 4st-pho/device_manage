import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
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
      body: _buildListMyDevice(),
    );
  }

  Widget _buildListMyDevice() {
    return FutureBuilder<List<Device>>(
      future: DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
          .getOwnerDevices(currentUser!.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userOrderDevices = snapshot.data as List<Device>;
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
