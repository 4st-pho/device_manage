import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/device_card.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    return Scaffold(
      appBar: _buildAppBar(context, searchBloc.keywork),
      body: Column(
        children: [
          // _buildSelectChoiceChip(),
          _buildContent(searchBloc.seachDevicesResult),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String keywork) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace),
      ),
      title: Text(keywork),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 2,
    );
  }

  Widget _buildContent(List<Device> data) {
    return Expanded(
        child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return DeviceCard(device: data[index]);
      },
    ));
  }
}
