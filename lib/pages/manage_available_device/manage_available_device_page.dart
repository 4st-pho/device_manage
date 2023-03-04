import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_available_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/empty_list.dart';
import 'package:provider/provider.dart';

class ManageAvailableDevicePage extends StatefulWidget {
  const ManageAvailableDevicePage({Key? key}) : super(key: key);

  @override
  State<ManageAvailableDevicePage> createState() =>
      _ManageAvailableDevicePageState();
}

class _ManageAvailableDevicePageState extends State<ManageAvailableDevicePage> {
  late final ManageAvailableDeviceBloc _manageAvailableDeviceBloc;
  @override
  void initState() {
    _manageAvailableDeviceBloc = context.read<ManageAvailableDeviceBloc>();
    _manageAvailableDeviceBloc.updateListDeviceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Device>>(
      stream: _manageAvailableDeviceBloc.listDeviceStream,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          final String error = snapshot.error.toString();
          return Center(child: Text(error));
        } else if (snapshot.hasData) {
          final listDevice = snapshot.data ?? [];
          if (listDevice.isEmpty) return const EmptyList();
          return _buildListDeviceItem(listDevice);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildListDeviceItem(List<Device> listDevice) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listDevice.length,
      itemBuilder: (BuildContext context, int index) {
        final device = listDevice[index];
        return _buildDeviceItem(device);
      },
    );
  }

  Widget _buildDeviceItem(Device device) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.detailDeviceRoute,
        arguments: device,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: _buildListTileDevice(device),
            ),
            if ((device.ownerId).isEmpty || device.ownerType == OwnerType.none)
              _buildProvideDeviceButton(device)
          ],
        ),
      ),
    );
  }

  Widget _buildProvideDeviceButton(Device device) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      width: 100,
      height: 40,
      child: CustomButton(
        text: AppString.provide,
        color: Colors.green,
        onPressed: () => Navigator.of(context).pushNamed(
          Routes.provideDeviceRoute,
          arguments: device,
        ),
      ),
    );
  }

  Widget _buildListTileDevice(Device device) {
    return ListTile(
      title: Text(device.name, maxLines: 2, overflow: TextOverflow.ellipsis),
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
    );
  }
}