import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SelectTeamBox extends StatelessWidget {
  final String lable;
  const SelectTeamBox({
    Key? key,
    required this.lable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(lable),
        ),
        InkWell(
          onTap: () {
            _showBottomSheetChooseValue(
              context,
              searchBloc.onChooseTeam,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<String?>(
                    stream: searchBloc.teamStream,
                    builder: (context, snapshot) {
                      searchBloc.sinkTeam();
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      final teamName = snapshot.data;
                      if (teamName == null || teamName.isEmpty) {
                        return const Spacer();
                      }
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(teamName,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            InkWell(
                              onTap: () => searchBloc.onClearTeam(),
                              child: const Icon(Icons.clear),
                            ),
                          ],
                        ),
                      );
                    }),
                const SizedBox(width: 14),
                const Icon(Icons.unfold_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showBottomSheetChooseValue(
      BuildContext context, void Function(Team) onChooseTeam) {
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
            initialData: const [],
            future: TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
                .getAllTeam(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              final List<Team> listTeam = snapshot.data??[];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: listTeam.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onChooseTeam(listTeam[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppDecoration.boxDecoration,
                      child: Text(listTeam[index].name),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
