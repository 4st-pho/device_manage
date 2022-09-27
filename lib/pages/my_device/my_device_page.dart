import 'package:manage_devices_app/bloc/devices_bloc/my_device_bloc.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/empty_list.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/device_card.dart';

class MyDevicePage extends StatefulWidget {
  const MyDevicePage({Key? key}) : super(key: key);

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage> {
  late final MyDeviceBloc _myDeviceBloc;
  @override
  void initState() {
    super.initState();
    _myDeviceBloc = context.read<MyDeviceBloc>();
  }

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
    final size = MediaQuery.of(context).size;
    final currentUser = context.read<AppData>().currentUser;
    return FutureBuilder<List<Device>>(
      future: _myDeviceBloc.getOwnerDevices(currentUser!.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDevices = snapshot.data as List<Device>;
          if (userDevices.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: size.height / 5),
              child: const EmptyList(),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            primary: false,
            itemCount: userDevices.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DeviceCard(device: userDevices[index]),
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
