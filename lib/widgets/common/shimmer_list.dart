import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/widgets/shimmer/device_card_shimmer.dart';
import 'package:manage_devices_app/widgets/shimmer/request_info_shimmer.dart';
import 'package:manage_devices_app/widgets/shimmer/request_shimmer.dart';

class ShimmerList {
  static final deviceCard = ListView(
    shrinkWrap: true,
    primary: false,
    padding: const EdgeInsets.all(8),
    children: const [
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: DeviceCardShimmer(),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: DeviceCardShimmer(),
      ),
    ],
  );
  static final requestItem = ListView(
    shrinkWrap: true,
    primary: false,
    padding: const EdgeInsets.all(8),
    children: const [
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 24),
      RequestShimmer(),
      SizedBox(height: 32),
    ],
  );

  static const requestInfo = RequestInfoShimmer();
}
