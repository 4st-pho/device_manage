import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
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
          if (isOwner)
            Expanded(
              flex: 5,
              child: CustomButton(
                  text: 'Recall',
                  onPressed: () {
                    Navigator.of(context).pop();
                    DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                        .recallDevice(context, device.id);
                  }),
            ),
          if (!isOwner)
            Expanded(
              flex: 5,
              child: CustomButton(
                text: 'Delete',
                onPressed: () {
                  Navigator.of(context).pop();
                  DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
                      .deleteDevice(context, device.id);
                },
              ),
            ),
        ],
      ),
    );
  }
}
