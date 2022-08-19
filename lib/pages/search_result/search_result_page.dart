import 'package:flutter/material.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/device_card.dart';

class SearchResultPage extends StatelessWidget {
  final String keywork;
  final List<Device> data;

  const SearchResultPage({
    Key? key,
    required this.keywork,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // _buildSelectChoiceChip(),
          _buildContent(data),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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

  Expanded _buildContent(List<Device> data) {
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

  // SizedBox _buildSelectChoiceChip() {
  //   return SizedBox(
  //     height: 60,
  //     child: StreamBuilder<int>(
  //       stream: _searchResultBloc.streamChoiceChip,
  //       initialData: 0,
  //       builder: (context, snapshot) {
  //         final data = snapshot.data;
  //         return ListView(
  //           padding: const EdgeInsets.all(12),
  //           scrollDirection: Axis.horizontal,
  //           children: [
  //             ChoiceChip(
  //               label: const Text(AppString.all),
  //               selected: data == 0 ? true : false,
  //               selectedColor: Colors.red,
  //               disabledColor: AppColor.dartBlue,
  //               onSelected: (_) => _searchResultBloc.selectedChoiceChip(0),
  //             ),
  //             const SizedBox(width: 12),
  //             ChoiceChip(
  //               label: const Text(AppString.device),
  //               selected: data == 1 ? true : false,
  //               selectedColor: Colors.red,
  //               disabledColor: AppColor.dartBlue,
  //               onSelected: (_) => _searchResultBloc.selectedChoiceChip(1),
  //             ),
  //             const SizedBox(width: 12),
  //             ChoiceChip(
  //               label: const Text(AppString.user),
  //               selected: data == 2 ? true : false,
  //               selectedColor: Colors.red,
  //               disabledColor: AppColor.dartBlue,
  //               onSelected: (_) => _searchResultBloc.selectedChoiceChip(2),
  //             ),
  //             const SizedBox(width: 12),
  //             ChoiceChip(
  //               label: const Text(AppString.team),
  //               selected: data == 3 ? true : false,
  //               selectedColor: Colors.red,
  //               disabledColor: AppColor.dartBlue,
  //               onSelected: (_) => _searchResultBloc.selectedChoiceChip(3),
  //             ),
  //             const SizedBox(width: 12),
  //             ChoiceChip(
  //               label: const Text(AppString.availableDevice),
  //               selected: data == 4 ? true : false,
  //               selectedColor: Colors.red,
  //               disabledColor: AppColor.dartBlue,
  //               onSelected: (_) => _searchResultBloc.selectedChoiceChip(4),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }
}
