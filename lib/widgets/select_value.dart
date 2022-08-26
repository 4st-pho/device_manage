import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/select_bottom_sheet_salue_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SelectBottomSheetValue extends StatelessWidget {
  final SelectBottomSheetValueBloc selectBottomSheetValueBloc;
  final String lable;
  const SelectBottomSheetValue({
    Key? key,
    required this.selectBottomSheetValueBloc,
    required this.lable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSelectBox(
      context: context,
      lable: lable,
      selectBottomSheetValueBloc: selectBottomSheetValueBloc,
    );
  }

  Column _buildSelectBox({
    required BuildContext context,
    required SelectBottomSheetValueBloc selectBottomSheetValueBloc,
    required String lable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(lable),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.red,
          onTap: () {
            _showBottomSheetChooseValue(
              context,
              selectBottomSheetValueBloc.getData,
              selectBottomSheetValueBloc.onChooseValue,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<dynamic>(
                    initialData: selectBottomSheetValueBloc.value,
                    stream: selectBottomSheetValueBloc.stream,
                    builder: (context, snapshot) {
                      selectBottomSheetValueBloc.sink();
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      final data = snapshot.data;
                      if (data == null) {
                        return const Spacer();
                      }
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(data.name,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            if (data != null)
                              InkWell(
                                onTap: selectBottomSheetValueBloc.onClear,
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

  Future<dynamic> _showBottomSheetChooseValue(BuildContext context,
      Future<List<dynamic>> getData, void Function(dynamic) onChooseValue) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FutureBuilder<List<dynamic>>(
            future: getData,
            initialData: const [],
            builder: (context, snapshot) {
              final data = snapshot.data!;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onChooseValue(data[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppDecoration.boxDecoration,
                      child: Text(data[index].name),
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
