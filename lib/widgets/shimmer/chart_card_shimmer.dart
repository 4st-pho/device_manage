import 'package:flutter/material.dart';
import 'package:manage_devices_app/widgets/shimmer/shimmer_widget.dart';

class ChartCardShimmer extends StatelessWidget {
  const ChartCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: ShimmerWidget(
          height: double.infinity,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
