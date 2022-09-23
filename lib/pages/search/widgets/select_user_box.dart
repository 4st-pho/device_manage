import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_decoration.dart';

class SelectUserBox extends StatefulWidget {
  const SelectUserBox({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectUserBox> createState() => _SelectUserBoxState();
}

class _SelectUserBoxState extends State<SelectUserBox> {
  late final SearchBloc _searchBloc;
  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        InkWell(
          onTap: () => _showBottomSheetChooseValue(context),
          child: _buildSelectUserBox(),
        ),
      ],
    );
  }

  Widget _buildSelectUserBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppDecoration.boxDecoration,
      child: Row(
        children: [
          StreamBuilder<User?>(
              stream: _searchBloc.userStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                final user = snapshot.data;
                if (user == null) {
                  return const Spacer();
                }
                return _buildUserNameBox(user);
              }),
          const SizedBox(width: 14),
          const Icon(Icons.unfold_more),
        ],
      ),
    );
  }

  Widget _buildUserNameBox(User user) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Text(user.name, overflow: TextOverflow.ellipsis),
          ),
          InkWell(
            onTap: () => _searchBloc.clearUser(),
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(AppString.chooseUser),
    );
  }

  Future<void> _showBottomSheetChooseValue(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildListUser(),
        );
      },
    );
  }

  FutureBuilder<List<User>> _buildListUser() {
    return FutureBuilder<List<User>>(
      initialData: const [],
      future: _searchBloc.getAllUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final List<User> listUser = snapshot.data!;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: listUser.length,
          itemBuilder: (ctx, index) {
            final user = listUser[index];
            return _buildListUserItem(user);
          },
        );
      },
    );
  }

  Widget _buildListUserItem(User user) {
    return InkWell(
      onTap: () {
        _searchBloc.chooseUser(user);
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
