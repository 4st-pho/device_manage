import 'package:flutter/material.dart';
import 'package:manage_devices_app/widgets/shimmer/shimmer_widget.dart';

class RequestShimmer extends StatelessWidget {
  const RequestShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      height: 80,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
