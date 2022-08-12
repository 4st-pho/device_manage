import 'package:flutter/material.dart';
import 'package:manage_devices_app/widgets/shimmer/shimmer_widget.dart';

class DeviceCardShimmer extends StatelessWidget {
  const DeviceCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          const ShimmerWidget(
            height: 200,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(height: 20),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(child: ShimmerWidget(height: 20)),
                    Spacer(),
                    Expanded(child: ShimmerWidget(height: 20)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
