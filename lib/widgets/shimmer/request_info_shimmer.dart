import 'package:flutter/material.dart';
import 'package:manage_devices_app/widgets/shimmer/shimmer_widget.dart';

class RequestInfoShimmer extends StatelessWidget {
  const RequestInfoShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: const ShimmerWidget(
        height: 100,
      ),
    );
  }
}
