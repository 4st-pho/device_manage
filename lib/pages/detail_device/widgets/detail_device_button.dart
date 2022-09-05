import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/show_dialog.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';

class DetailDeviceButton extends StatelessWidget {
  final Device device;
  const DetailDeviceButton({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwner = device.ownerId != null;
    return Padding(
      padding: const EdgeInsets.all(12),
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
                color: Colors.orange,
                onPressed: () => showCustomDialog(
                  color: Colors.orange,
                  context: context,
                  title: AppString.confirm,
                  content: AppString.deviceWillbeRecall,
                  onAgree: () {
                    DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .recallDevice(device.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          if (!isOwner)
            Expanded(
              flex: 5,
              child: CustomButton(
                text: AppString.delete,
                color: Colors.red,
                onPressed: () => showCustomDialog(
                  context: context,
                  title: AppString.confirm,
                  content: AppString.deviceWillBeDelete,
                  onAgree: () {
                    DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .deleteDevice(device.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
