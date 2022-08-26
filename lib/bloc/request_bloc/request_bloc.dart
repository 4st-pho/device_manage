import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/model/request.dart';

class RequestBloc {
  final List<Request> _myProcessingRequestManage = [];
  final List<Request> _myHandledRequestManage = [];
  List<Request> get myProcessingRequestManage => _myProcessingRequestManage;
  List<Request> get myHandledRequestManage => _myHandledRequestManage;
  void onRequestChange(List<Request> requests) {
    for (Request e in requests) {
      if (e.requestStatus == RequestStatus.pending ||
          e.requestStatus == RequestStatus.approved) {
        _myProcessingRequestManage.add(e);
      } else {
        _myHandledRequestManage.add(e);
      }
    }
  }
  void dispose(){
    
  }
}
