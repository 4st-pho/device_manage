import 'package:flutter/material.dart';
import 'package:manage_devices_app/widgets/shimmer/shimmer_widget.dart';

class ListResultShimmer extends StatelessWidget {
  const ListResultShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child:  ShimmerWidget(height: 30),
    );
  }
}
