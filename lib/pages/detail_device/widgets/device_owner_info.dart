import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/devices_bloc/detail_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/widgets/base_info.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';
import 'package:provider/provider.dart';

class DeviceOwnerInfo extends StatefulWidget {
  final String ownerId;
  final OwnerType ownerType;

  const DeviceOwnerInfo(
      {Key? key, required this.ownerId, required this.ownerType})
      : super(key: key);

  @override
  State<DeviceOwnerInfo> createState() => DeviceOwnerInfoState();
}

class DeviceOwnerInfoState extends State<DeviceOwnerInfo> {
  late final DetailDeviceBloc _detailDeviceBloc;
  @override
  void initState() {
    super.initState();
    _detailDeviceBloc = context.read<DetailDeviceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDivider(text: AppString.ownerInfo),
        _buildOwnerInfo()
      ],
    );
  }

  Widget _buildOwnerInfo() {
    if (widget.ownerType == OwnerType.user) return _buildUserInfo();
    return _buildTeamInfo();
  }

  Widget _buildUserInfo() {
    return FutureBuilder<User>(
      future: _detailDeviceBloc.getUser(widget.ownerId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return BaseInfo(
              imagePath: user.avatar,
              title: user.name,
              subtitle: 'Age: ${user.age}',
              info: 'Address: ${user.address}');
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return ShimmerList.requestInfo;
      },
    );
  }

  Widget _buildTeamInfo() {
    return FutureBuilder<Team>(
      future: _detailDeviceBloc.getTeam(widget.ownerId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final team = snapshot.data!;
          return BaseInfo(
              imagePath: team.imagePath, title: 'Team: ${team.name}');
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return ShimmerList.requestInfo;
      },
    );
  }
}
