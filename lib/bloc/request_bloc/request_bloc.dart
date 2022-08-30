import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/enums/tab_request.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';

class RequestBloc {
  TabRequest _currentTab = TabRequest.processing;
  List<Request> _listAllRequest = [];

  final StreamController<List<Request>> _listRequestController =
      StreamController<List<Request>>();
  RequestBloc() {
    init();
  }

  Stream<List<Request>> get listRequestStream => _listRequestController.stream;
  TabRequest get currentTab => _currentTab;
  Future<void> init() async {
    final List<String> userCredential =
        await SharedPreferencesMethod.getUserUserCredential();
    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
        .streamListRequest(userCredential[0],
            Role.values.byName(userCredential[1]), userCredential[2])
        .listen((data) {
      _listAllRequest = data;
      onTabChange(_currentTab);
    });
  }

  void onTabChange(TabRequest tabRequest) {
    _currentTab = tabRequest;
    if (tabRequest == TabRequest.processing) {
      List<Request> myProcessingRequestManage = _listAllRequest
          .where((e) =>
              e.requestStatus == RequestStatus.pending ||
              e.requestStatus == RequestStatus.approved)
          .toList();
      _listRequestController.sink.add(myProcessingRequestManage);
    } else {
      List<Request> myHandledRequestManage = _listAllRequest
          .where((e) =>
              e.requestStatus != RequestStatus.pending &&
              e.requestStatus != RequestStatus.approved)
          .toList();
      _listRequestController.sink.add(myHandledRequestManage);
    }
  }

  void dispose() {
    _listRequestController.close();
  }
}
