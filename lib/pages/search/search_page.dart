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

  /// run when click one iteam in list suggest
  void submited(String deviceName) {
    _searchController.text = deviceName;
    context.read<SearchBloc>().submitted(query: deviceName);
    Navigator.of(context).pushNamed(
      Routes.searchResultRoute,
      arguments: context.read<SearchBloc>(),
    );
  }

  /// run when click  search button in keyboard
  void keyboardSubmited() {
    context.read<SearchBloc>().submitted();
    Navigator.of(context).pushNamed(
      Routes.searchResultRoute,
      arguments: _searchBloc,
    );
  }

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

  Widget _buildSearch() {
    return SearchTextField(
      hintText: AppString.searchDevice,
      controller: _searchController,
      onChanged: _searchBloc.onSearch,
      iconData: Icons.filter_alt_rounded,
      onSuffixPresses: () => _showBottomSheet(),
      onSubmitted: (_) => keyboardSubmited(),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: StreamBuilder<List<Device>>(
        stream: context.read<SearchBloc>().searchDevicesResultStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error.toString();
            return Center(
              child: Text(error),
            );
          } else if (snapshot.hasData) {
            final listDevice = snapshot.data ?? [];
            return _buildSuggestDevice(listDevice);
          } else {
            return ShimmerList.listResult;
          }
        },
      ),
    );
  }

  Widget _buildSuggestDevice(List<Device> listDevice) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listDevice.length,
      itemBuilder: (context, index) {
        final String deviceName = listDevice[index].name;
        return _buildSuggestDeviceItem(deviceName);
      },
    );
  }

  Widget _buildSuggestDeviceItem(String deviceName) {
    return InkWell(
      onTap: () => submited(deviceName),
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
          child: _buildBottomSheetContent(),
        );
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return StreamBuilder<SearchFilter?>(
      stream: _searchBloc.filterSwitchAdapterStream,
      builder: (context, snapshot) {
        final searchFilter = snapshot.data;
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            /// _buildSwitchListTile for select available device
            _buildSwitchListTile(
              searchFilter: searchFilter,
              valueFilter: SearchFilter.avalbleDevice,
              onChanged: _searchBloc.avalbleDeviceFilter,
              title: AppString.searchAvalbleDevices,
            ),

            /// _buildSwitchListTile for select team device
            _buildSwitchListTile(
              searchFilter: searchFilter,
              valueFilter: SearchFilter.teamDevice,
              onChanged: _searchBloc.teamFilter,
              title: AppString.searchTeamDevices,
            ),

            if (searchFilter == SearchFilter.teamDevice)
              Provider.value(
                value: _searchBloc,
                child: const SelectTeamBox(),
              ),

            /// _buildSwitchListTile for select user device
            _buildSwitchListTile(
              searchFilter: searchFilter,
              valueFilter: SearchFilter.userDevice,
              onChanged: _searchBloc.userFilter,
              title: AppString.searchUserDevices,
            ),
            if (searchFilter == SearchFilter.userDevice)
              Provider.value(
                value: _searchBloc,
                child: const SelectUserBox(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSwitchListTile(
      {required SearchFilter? searchFilter,
      required SearchFilter valueFilter,
      required void Function(bool) onChanged,
      required String title}) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.all(0),
      value: searchFilter == valueFilter,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
