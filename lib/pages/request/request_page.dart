import 'package:manage_devices_app/bloc/request_bloc/request_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/enums/tab_request.dart';
import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/pages/request/widgets/request_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: DefaultTabController(
        length: 2,
        child: _buildContent(context),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser;
    return AppBar(
      title: const Text(AppString.allrequest),
      backgroundColor: Colors.black.withOpacity(0.6),
      elevation: 0,
      actions: [
        if (currentUser!.role != Role.admin)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.createRequestRoute),
              icon: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    // final currentUser = context.read<AppData>().currentUser!;
    final requestBloc = context.read<RequestBloc>();
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(child: Text(AppString.processing)),
              Tab(child: Text(AppString.handled)),
            ],
            indicatorColor: AppColor.dartBlue,
            onTap: (tabIndex) {
              if (tabIndex == 0) {
                requestBloc.onTabChange(TabRequest.processing);
              } else {
                requestBloc.onTabChange(TabRequest.handled);
              }
            },
          ),
          Expanded(
              child: StreamBuilder<List<Request>>(
            stream: requestBloc.listRequestStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                final String error = snapshot.error.toString();
                return Center(child: Text(error));
              } else if (snapshot.hasData) {
                final List<Request> myRequestManage = snapshot.data ?? [];
                return _buildRequestContent(myRequestManage);
              }
              return ShimmerList.requestItem;
            },
          ))
        ],
      ),
    );
  }

  Widget _buildRequestContent(List<Request> requests) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
      physics: const BouncingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RequestItem(request: requests[index]),
      ),
    );
  }
}
