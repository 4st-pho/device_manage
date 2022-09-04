import 'dart:async';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';

class CreateRequestBloc {
  Device? _avalbleDevice;
  Device? _myDevice;
  ErrorStatus? _deviceErrorStatus;
  bool _isRequestNewDevice = false;
  List<ErrorStatus> listErrorStatus = [
    ErrorStatus.software,
    ErrorStatus.hardware
  ];
  final request = Request(
    uid: '',
    id: '',
    deviceId: '',
    title: '',
    content: '',
    requestStatus: RequestStatus.pending,
    errorStatus: ErrorStatus.software,
  );
  final StreamController<bool> _isRequestNewDeviceController =
      StreamController<bool>();
  final StreamController<List<Device>> _myDeviceManageController =
      StreamController<List<Device>>.broadcast();
  final StreamController<Device?> _availbleDeviceController =
      StreamController<Device?>.broadcast();
  Stream<Device?> get availbleDeviceStream => _availbleDeviceController.stream;
  Stream<bool> get isRequestNewDeviceStream =>
      _isRequestNewDeviceController.stream;
  Stream<List<Device>> get myDeviceManageStream =>
      _myDeviceManageController.stream;
  Device? get myDevide => _myDevice;
  Device? get avalbleDevice => _avalbleDevice;
  bool get isRequestNewDevice => _isRequestNewDevice;
  ErrorStatus? get deviceErrorStatus => _deviceErrorStatus;

  void onCheckBoxNewDevice(bool? value) {
    _isRequestNewDevice = value ?? false;
    _isRequestNewDeviceController.sink.add(_isRequestNewDevice);
  }

  void onChooseAvailbleDevice(Device? device) {
    if (device != null) {
      _avalbleDevice = device;
      request.deviceId = _avalbleDevice!.id;
      _availbleDeviceController.sink.add(_avalbleDevice);
    }
  }

  void changeErrorStatus(ErrorStatus? errorStatus) {
    if (errorStatus != null) {
      _deviceErrorStatus = errorStatus;
      request.errorStatus = errorStatus;
    }
  }

  void changeDeviceId(Device? device) {
    if (device != null) {
      request.deviceId = device.id;
      _myDevice = device;
    }
  }

  Future<void> sendRequest(String title, String content) async {
    if (isRequestNewDevice) {
      request.errorStatus = ErrorStatus.noError;
    }

    List<String> userUserCredential =
        await SharedPreferencesMethod.getUserUserCredential();
    final Role role = Role.values.byName(userUserCredential[1]);
    final String uid = userUserCredential[0];
    request.uid = uid;
    if (role == Role.leader) {
      request.requestStatus = RequestStatus.approved;
    }
    request.title = title.trim();
    request.content = content.trim();
    await RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
        .createRequest(request);
  }

  void dispose() {
    _availbleDeviceController.close();
    _myDeviceManageController.close();
    _isRequestNewDeviceController.close();
  }
}
