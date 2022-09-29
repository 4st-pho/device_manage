import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/widgets/empty_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/device_card.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late final SearchBloc _searchBloc;
  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: Text(
        'Result for " ${_searchBloc.keywork}"',
        style: AppStyle.whiteTitle,
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<Device>>(
      stream: _searchBloc.searchDevicesResultStream,
      builder: (context, snapshot) {
        final listResultDevice = snapshot.data ?? [];
        return buildListResultDevice(listResultDevice);
      },
    );
  }

  Widget buildListResultDevice(List<Device> listResultDevice) {
    if (listResultDevice.isEmpty) return const EmptyList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listResultDevice.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: DeviceCard(device: listResultDevice[index]),
        );
      },
    );
  }
}
