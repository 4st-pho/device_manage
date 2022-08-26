import 'package:manage_devices_app/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/pages/request/widgets/request_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
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
      backgroundColor: Colors.black.withOpacity(.6),
      elevation: 0,
      actions: [
        if (currentUser!.role != Role.admin)
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.createRequestRoute),
            icon: const Icon(Icons.add),
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final currentUser = context.read<AppData>().currentUser!;
    return StreamBuilder<List<Request>>(
      stream: RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
          .streamListRequest(
              currentUser.role, currentUser.id, currentUser.teamId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(tabs: [
                  Tab(child: Text('z')),
                  Tab(child: Text('t')),
                ]),
                Expanded(
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RequestItem(request: data[index]),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RequestItem(request: data[index]),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
        }
        return ShimmerList.requestItem;
      },
    );
  }
}
