import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';

class ManageDevice extends StatelessWidget {
  final Device device;
  const ManageDevice({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwner = device.ownerId != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomButton(
              text: AppString.edit,
              onPressed: () => Navigator.of(context)
                  .pushNamed(Routes.editDeviceRoute, arguments: device),
            ),
          ),
          const SizedBox(width: 16),
          if (isOwner)
            Expanded(
              flex: 5,
              child: CustomButton(
                  text: AppString.recall,
                  onPressed: () {
                    Navigator.of(context).pop();
                    DeviceService().recallDevice(device.id);
                  }),
            ),
          if (!isOwner)
            Expanded(
              flex: 5,
              child: CustomButton(
                text: AppString.delete,
                onPressed: () {
                  Navigator.of(context).pop();
                  DeviceService().deleteDevice(device.id);
                },
              ),
            ),
        ],
      ),
    );
  }
}
