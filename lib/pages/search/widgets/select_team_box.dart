import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SelectTeamBox extends StatefulWidget {
  const SelectTeamBox({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectTeamBox> createState() => _SelectTeamBoxState();
}

class _SelectTeamBoxState extends State<SelectTeamBox> {
  late final SearchBloc _searchBloc;
  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        InkWell(
          onTap: () => _showBottomSheetChooseValue(context),
          child: _buildSelectTeamBox(),
        ),
      ],
    );
  }

  Widget _buildSelectTeamBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppDecoration.boxDecoration,
      child: Row(
        children: [
          StreamBuilder<Team?>(
              stream: _searchBloc.teamStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                final team = snapshot.data;
                if (team == null) {
                  return const Spacer();
                }
                return _buildTeamNameBox(team.name);
              }),
          const SizedBox(width: 14),
          const Icon(Icons.unfold_more),
        ],
      ),
    );
  }

  Widget _buildTeamNameBox(String teamName) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Text(teamName, overflow: TextOverflow.ellipsis),
          ),
          InkWell(
            onTap: () => _searchBloc.clearTeam(),
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(AppString.chooseTeam),
    );
  }

  Future<void> _showBottomSheetChooseValue(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildListTeam(),
        );
      },
    );
  }

  Widget _buildListTeam() {
    return FutureBuilder<List<Team>>(
      initialData: const [],
      future: _searchBloc.getAllTeam(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final List<Team> listTeam = snapshot.data!;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: listTeam.length,
          itemBuilder: (ctx, index) {
            final team = listTeam[index];
            return _buildListTeamItem(team);
          },
        );
      },
    );
  }

  Widget _buildListTeamItem(Team team) {
    return InkWell(
      onTap: () {
        _searchBloc.onChooseTeam(team);
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
