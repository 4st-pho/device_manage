import 'dart:async';

import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/tab_request.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';

class RequestBloc {
  TabRequest _currentTab = TabRequest.processing;
  List<Request> _listAllRequest = [];

  /// init _updateRealtimeRequestStatus for cancel listen stream when dispose
  late final StreamSubscription _listRequestStreamSubscription;

  /// show list request realtime
  final _listRequestController = StreamController<List<Request>>();
  Stream<List<Request>> get listRequestStream => _listRequestController.stream;

  RequestBloc() {
    setListRequestRealTime();
  }

  Future<void> setListRequestRealTime() async {
    final User userCredential =
        await SharedPreferencesMethod.getCurrentUserFromLocal();
    _listRequestStreamSubscription = RequestService()
        .streamListRequest(
            userCredential.id, userCredential.role, userCredential.teamId)
        .listen((data) {
      _listAllRequest = data;
      updateListRequest();
    });
  }

  TabRequest defineTab(int index) {
    switch (index) {
      case 0:
        return TabRequest.processing;
      case 1:
        return TabRequest.handled;

      default:
        return TabRequest.processing;
    }
  }

  void onTabChange(int index) {
    _currentTab = defineTab(index);
    updateListRequest();
  }

  void updateListRequest() {
    if (_currentTab == TabRequest.processing) {
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
    _listRequestStreamSubscription.cancel();
  }
}
