import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/enums/search_filter.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/pages/search/widgets/select_team_box.dart';
import 'package:manage_devices_app/pages/search/widgets/select_user_box.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:provider/provider.dart';

import 'package:manage_devices_app/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late SearchBloc _searchBloc;
  @override
  void initState() {
    _searchController = TextEditingController();
    _searchBloc = context.read<SearchBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildSearch(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  SearchTextField _buildSearch() {
    return SearchTextField(
      hintText: AppString.searchDevice,
      controller: _searchController,
      onChanged: _searchBloc.onTextChange,
      iconData: Icons.filter_alt_rounded,
      onSuffixPresses: () => _showBottomSheet(),
      onSubmitted: (_) {
        context.read<SearchBloc>().onSubmitted(_searchController);
        Navigator.of(context).pushNamed(
          Routes.searchResultRoute,
          arguments: _searchBloc,
        );
      },
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: StreamBuilder<List<Device>>(
        stream: context.read<SearchBloc>().currentDevicesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error.toString();
            return Center(
              child: Text(error),
            );
          } else if (snapshot.hasData) {
            final listDevice = snapshot.data ?? [];
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listDevice.length,
              itemBuilder: (context, index) {
                final String deviceName = listDevice[index].name;
                return InkWell(
                  onTap: () {
                    context
                        .read<SearchBloc>()
                        .onSubmitted(_searchController, query: deviceName);
                    Navigator.of(context).pushNamed(
                      Routes.searchResultRoute,
                      arguments: context.read<SearchBloc>(),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(deviceName),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            );
          } else {
            return ShimmerList.listResult;
          }
        },
      ),
    );
  }

  Future<void> _showBottomSheet() {
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
              final searchFilter = snapshot.data ?? [];
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SwitchListTile.adaptive(
                    value: searchFilter.contains(SearchFilter.avalbleDevice),
                    onChanged: _searchBloc.avalbleDeviceFilter,
                    title: const Text(AppString.searchAvalbleDevices),
                  ),
                  SwitchListTile.adaptive(
                    value: searchFilter.contains(SearchFilter.team),
                    onChanged: _searchBloc.teamFilter,
                    title: const Text(AppString.searchTeamDevices),
                  ),
                  if (searchFilter.contains(SearchFilter.team))
                    Provider.value(
                      value: _searchBloc,
                      builder: (context, _) {
                        return const SelectTeamBox(lable: AppString.chooseTeam);
                      },
                    ),
                  SwitchListTile.adaptive(
                    value: searchFilter.contains(SearchFilter.user),
                    onChanged: _searchBloc.userFilter,
                    title: const Text(AppString.searchUserDevices),
                  ),
                  if (searchFilter.contains(SearchFilter.user))
                    Provider.value(
                      value: _searchBloc,
                      builder: (context, _) {
                        return const SelectUserBox(
                          lable: AppString.chooseUser,
                        );
                      },
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
