import 'package:manage_devices_app/bloc/devices_bloc/provide_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class BottomSheetChooseTeam extends StatefulWidget {
  const BottomSheetChooseTeam({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetChooseTeam> createState() => _BottomSheetChooseTeamState();
}

class _BottomSheetChooseTeamState extends State<BottomSheetChooseTeam> {
  late final ProvideDeviceBloc _provideDeviceBloc;

  @override
  void initState() {
    super.initState();
    _provideDeviceBloc = context.read<ProvideDeviceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(AppString.chooseTeam),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showBottomSheetChooseTeam(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                _buildStreamTeam(),
                const SizedBox(width: 14),
                const Icon(Icons.unfold_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamTeam() {
    return StreamBuilder<Team?>(
      stream: _provideDeviceBloc.teamStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          return Center(child: Text(error));
        }
        final teamName = snapshot.data;
        if (teamName == null) {
          return const Spacer();
        } else {
          return Expanded(
            child: Text(teamName.name, overflow: TextOverflow.ellipsis),
          );
        }
      },
    );
  }

  Future<void> _showBottomSheetChooseTeam() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FutureBuilder<List<Team>>(
            future: _provideDeviceBloc.getAllTeam(),
            initialData: const [],
            builder: (context, snapshot) {
              final allTeam = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: allTeam.length,
                itemBuilder: (context, index) {
                  final team = allTeam[index];
                  return _buildSelectBottomSheetItem(team);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectBottomSheetItem(Team team) {
    return InkWell(
      onTap: () {
        _provideDeviceBloc.setTeam(team);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: AppDecoration.boxDecoration,
        child: Text(team.name),
      ),
    );
  }
}
