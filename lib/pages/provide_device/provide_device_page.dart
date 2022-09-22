import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/select_bottom_sheet_salue_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/provide_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/services/clound_firestore/team_service.dart';
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';
import 'package:manage_devices_app/widgets/select_value.dart';

class ProvideDevicePage extends StatefulWidget {
  final Device device;
  const ProvideDevicePage({Key? key, required this.device}) : super(key: key);
  @override
  State<ProvideDevicePage> createState() => _ProvideDevicePageState();
}

class _ProvideDevicePageState extends State<ProvideDevicePage> {
  late final SelectBottomSheetValueBloc _chooseUserBloc;
  late final SelectBottomSheetValueBloc _chooseTeamBloc;
  late final ProviceDeviceBloc _proviceDeviceBloc;
  @override
  void initState() {
    _chooseUserBloc = SelectBottomSheetValueBloc(
      UserService().getAllUser(),
    );
    _chooseTeamBloc = SelectBottomSheetValueBloc(
      TeamService().getAllTeam(),
    );
    _proviceDeviceBloc = ProviceDeviceBloc(widget.device.id);
    super.initState();
  }

  @override
  void dispose() {
    _chooseUserBloc.dispose();
    _chooseTeamBloc.dispose();
    _proviceDeviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildInfo(), _buildContent()],
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  StreamBuilder<bool> _buildContent() {
    return StreamBuilder<bool>(
      stream: _proviceDeviceBloc.stream,
      initialData: _proviceDeviceBloc.isChooseUser,
      builder: (context, snapshot) {
        bool isShowUser = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButton(
                  value: _proviceDeviceBloc.value,
                  items: _proviceDeviceBloc.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: _proviceDeviceBloc.onChanged),
            ),
            isShowUser
                ? SelectBottomSheetValue(
                    selectBottomSheetValueBloc: _chooseUserBloc,
                    lable: AppString.chooseUser,
                  )
                : SelectBottomSheetValue(
                    selectBottomSheetValueBloc: _chooseTeamBloc,
                    lable: AppString.chooseTeam,
                  ),
          ],
        );
      },
    );
  }

  Padding _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomButton(
        text: AppString.done,
        onPressed: () {
          _proviceDeviceBloc.submit(_proviceDeviceBloc.isChooseUser
              ? _chooseUserBloc.value
              : _chooseTeamBloc.value);
        },
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.keyboard_backspace_rounded)),
      title: const Text('Provide Device'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  ListTile _buildInfo() {
    return ListTile(
      title: Text(
        widget.device.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(widget.device.healthyStatus.name),
      trailing: Text(widget.device.deviceType.name),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Image.network(
          widget.device.imagePaths[0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
