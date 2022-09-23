import 'package:manage_devices_app/bloc/devices_bloc/provide_device_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';
import 'package:manage_devices_app/model/user.dart';

class BottomSheetChooseUser extends StatefulWidget {
  const BottomSheetChooseUser({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetChooseUser> createState() => _BottomSheetChooseUserState();
}

class _BottomSheetChooseUserState extends State<BottomSheetChooseUser> {
  late final ProvideDeviceBloc _provideDeviceBloc;

  @override
  void initState() {
    super.initState();

    _provideDeviceBloc = context.read<ProvideDeviceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(AppString.chooseUser),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showBottomSheetChooseUser(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDecoration.boxDecoration,
            child: Row(
              children: [
                _buildStreamUser(),
                const SizedBox(width: 14),
                const Icon(Icons.unfold_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamUser() {
    return StreamBuilder<User?>(
      stream: _provideDeviceBloc.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          return Center(child: Text(error));
        }
        final user = snapshot.data;
        if (user == null) {
          return const Spacer();
        } else {
          return Expanded(
            child: Text(user.name, overflow: TextOverflow.ellipsis),
          );
        }
      },
    );
  }

  Future<void> _showBottomSheetChooseUser() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FutureBuilder<List<User>>(
            future: _provideDeviceBloc.getAllUser(),
            initialData: const [],
            builder: (context, snapshot) {
              final allUser = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: allUser.length,
                itemBuilder: (context, index) {
                  final user = allUser[index];
                  return _buildSelectBottomSheetItem(user);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectBottomSheetItem(User user) {
    return InkWell(
      onTap: () {
        _provideDeviceBloc.setUser(user);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: AppDecoration.boxDecoration,
        child: Text(user.name),
      ),
    );
  }
}
