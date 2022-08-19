import 'package:manage_devices_app/enums/search_filter.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:provider/provider.dart';

import 'package:manage_devices_app/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late final SearchBloc _searchBloc;
  @override
  void initState() {
    _searchController = TextEditingController();
    _searchBloc = SearchBloc();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: StreamBuilder<List<SearchFilter>>(
          stream: _searchBloc.filterStream,
          initialData: const [],
          builder: (context, snapshot) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildSearch(context),
                    _buildContent(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SearchTextField _buildSearch(BuildContext context) {
    return SearchTextField(
        hintText: AppString.searchDevice,
        controller: _searchController,
        onChanged: _searchBloc.onTextChange,
        iconData: Icons.filter_alt_rounded,
        onSuffixPresses: () {
          // _searchBloc.onSubmitted(context);
          _showBottomSheet(context);
        },
        onSubmitted: (_) {
          _searchBloc.onSubmitted(context, _searchController);
        });
  }

  Expanded _buildContent() {
    return Expanded(
      child: StreamBuilder<List<Device>>(
        stream: _searchBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _searchBloc.onSubmitted(
                        context, _searchController,
                        query: data[index].name),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[index].name),
                      ),
                    ]),
                  );
                });
          } else {
            return ShimmerList.listResult;
          }
        },
      ),
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(12),
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: StreamBuilder<List<SearchFilter>>(
            stream: _searchBloc.filterStream,
            initialData: _searchBloc.searchFilter,
            builder: (context, snapshot) {
              // _searchBloc.sinkSearchFilter();
              final data = snapshot.data;
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SwitchListTile.adaptive(
                    value: data!.contains(SearchFilter.avalbleDevice),
                    onChanged: _searchBloc.avalbleDeviceFilter,
                    title: const Text('Search avalble devices'),
                  ),
                  SwitchListTile.adaptive(
                    value: data.contains(SearchFilter.team),
                    onChanged: _searchBloc.teamFilter,
                    title: const Text('Search team devices'),
                  ),
                  if (data.contains(SearchFilter.team))
                    _buildSelectBox(
                        stream: _searchBloc.teamStream,
                        onTap: () {
                          _showBottomSheetChooseValue(
                            context,
                            context.read<AppData>().allTeam,
                            _searchBloc.onChooseTeam,
                          );
                        },
                        onClear: () => _searchBloc.onClearTeam(),
                        lable: 'Choose team'),
                  SwitchListTile.adaptive(
                    value: data.contains(SearchFilter.user),
                    onChanged: _searchBloc.userFilter,
                    title: const Text('Search user devices'),
                  ),
                  if (data.contains(SearchFilter.user))
                    _buildSelectBox(
                      stream: _searchBloc.userStream,
                      onTap: () {
                        _showBottomSheetChooseValue(
                          context,
                          context.read<AppData>().allUser,
                          _searchBloc.onChooseUser,
                        );
                      },
                      onClear: () => _searchBloc.onClearUser(),
                      lable: 'Choose user',
                    ),
                ],
              );
            },
          ),
        );
        //  SizedBox.expand(child:
      },
    );
  }

  Future<dynamic> _showBottomSheetChooseValue(
      BuildContext context, List<dynamic> data, void Function(dynamic) handle) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  handle(data[index]);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecoration.boxDecoration,
                  child: Text(data[index].name),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Column _buildSelectBox(
      {required VoidCallback onTap,
      required VoidCallback onClear,
      required String lable,
      required Stream<dynamic> stream}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(lable),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                StreamBuilder<dynamic>(
                    stream: stream,
                    builder: (context, snapshot) {
                      _searchBloc.sinkUserAndTeam();
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
                                onTap: onClear,
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
}
