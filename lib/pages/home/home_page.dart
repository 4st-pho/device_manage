import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/home_page_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/device_card.dart';
import 'package:manage_devices_app/widgets/empty_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageBloc _homePageBloc;
  @override
  void initState() {
    super.initState();
    _homePageBloc = context.read<HomePageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildTitle(),
          _buildListTeamDevice(context),
        ],
      ),
    );
  }

  Widget _buildListTeamDevice(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Device>>(
        future: _homePageBloc.getTeamDevices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userDevices = snapshot.data as List<Device>;
            if (userDevices.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: size.height / 5),
                child: const EmptyList(),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              primary: false,
              itemCount: userDevices.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DeviceCard(device: userDevices[index]),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return ShimmerList.deviceCard;
        },
      ),
    );
  }

  Widget _buildTitle() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4, color: AppColor.dartBlue),
              ),
            ),
            child: const Text(AppString.teamDevices, style: AppStyle.blueTitle),
          ),
        ],
      ),
    );
  }
}
