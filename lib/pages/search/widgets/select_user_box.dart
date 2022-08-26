import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SelectUserBox extends StatelessWidget {
  final String lable;
  const SelectUserBox({
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
              searchBloc.onChooseUser,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<String?>(
                    stream: searchBloc.userStream,
                    builder: (context, snapshot) {
                      searchBloc.sinkUser();
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      final userName = snapshot.data;
                      if (userName == null || userName.isEmpty) {
                        return const Spacer();
                      }
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(userName,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            InkWell(
                              onTap: () => searchBloc.onClearUser(),
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
      BuildContext context, void Function(User) onChooseUser) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FutureBuilder<List<User>>(
            initialData: const [],
            future: UserMethod(firebaseFirestore: FirebaseFirestore.instance)
                .getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              final List<User> listUser = snapshot.data!;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: listUser.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onChooseUser(listUser[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppDecoration.boxDecoration,
                      child: Text(listUser[index].name),
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
