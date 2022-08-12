import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/pages/request/widgets/request_item.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:manage_devices_app/services/init/init_data.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildContent(),
          const SliverToBoxAdapter(child: SizedBox(height: 70)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
      child: StreamBuilder<List<Request>>(
        stream: RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
            .streamListRequest(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              primary: false,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RequestItem(request: data[index]),
              ),
            );
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          return ShimmerList.requestItem;
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: const Text(AppString.allrequest),
      backgroundColor: Colors.black.withOpacity(.6),
      elevation: 2,
      actions: [
        if (currentUser!.role != Role.admin)
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.createRequestRoute),
            icon: const Icon(Icons.add),
          ),
        const SizedBox(width: 4)
      ],
    );
  }
}
