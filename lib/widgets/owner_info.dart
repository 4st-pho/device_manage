import 'package:flutter/material.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/team_service.dart';
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';
import 'package:manage_devices_app/widgets/base_info.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';

class OwnerInfo extends StatelessWidget {
  final String ownerId;
  final OwnerType ownerType;

  const OwnerInfo({Key? key, required this.ownerId, required this.ownerType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ownerType == OwnerType.user ? _buildUserInfo() : _buildTeamInfo();
  }

  FutureBuilder<User> _buildUserInfo() {
    return FutureBuilder<User>(
      future: UserService().getUser(ownerId),
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

  FutureBuilder<Team> _buildTeamInfo() {
    return FutureBuilder<Team>(
      future: TeamService().getTeam(ownerId),
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
