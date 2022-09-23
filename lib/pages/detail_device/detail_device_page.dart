import 'package:manage_devices_app/bloc/devices_bloc/detail_device_bloc.dart';
import 'package:manage_devices_app/pages/detail_device/widgets/detail_device_button.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:manage_devices_app/widgets/owner_info.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/widgets/text_divider.dart';

class DetailDevicePage extends StatefulWidget {
  final Device device;
  const DetailDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  State<DetailDevicePage> createState() => _DetailDevicePageState();
}

class _DetailDevicePageState extends State<DetailDevicePage> {
  late final DetailDeviceBloc _detailDeviceBloc;
  @override
  void initState() {
    super.initState();
    _detailDeviceBloc = context.read<DetailDeviceBloc>();
    _detailDeviceBloc.setRealtimeDevice(widget.device.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: StreamBuilder<Device>(
        stream: _detailDeviceBloc.deviceStream,
        initialData: widget.device,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildDetailDevice(
                device: widget.device, isShowAdminButton: false);
          }
          if (snapshot.hasData) {
            final deviceStream = snapshot.data!;
            return _buildDetailDevice(device: deviceStream);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailDevice(
      {required Device device, bool isShowAdminButton = true}) {
    final currentUser = context.read<AppData>().currentUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context, device),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContentItem(
                          title: AppString.name, content: device.name),
                      _buildContentItem(
                          title: AppString.type,
                          content: device.deviceType.name),
                      _buildContentItem(
                          title: AppString.healthyStatus,
                          content: device.healthyStatus.name),
                      _buildContentItem(
                          title: AppString.info, content: device.info),
                      if (device.transferDate != null)
                        _buildContentItem(
                          title: AppString.transferDate,
                          content: DateFormat('dd MMM yyyy')
                              .format(device.transferDate!),
                        ),
                      _buildContentItem(
                        title: AppString.manufacturingDate,
                        content: DateFormat('dd MMM yyyy')
                            .format(device.manufacturingDate),
                      ),
                      if (device.ownerId.isNotEmpty)
                        OwnerInfo(
                          ownerId: device.ownerId,
                          ownerType: device.ownerType,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (currentUser!.role == Role.admin && isShowAdminButton)
          DetailDeviceButton(device: device),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.3),
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.keyboard_backspace_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, Device deviceStream) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 300,
      width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: deviceStream.imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            deviceStream.imagePaths[index],
            width: size.width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildContentItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextDivider(text: title),
        Text(content, style: AppStyle.whiteText),
      ],
    );
  }
}
