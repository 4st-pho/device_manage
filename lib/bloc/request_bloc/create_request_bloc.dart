import 'dart:async';
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
  bool _requestNewDevice = false;
  final request = Request(
    uid: '',
    id: '',
    deviceId: '',
    title: '',
    content: '',
    requestStatus: RequestStatus.pending,
    errorStatus: ErrorStatus.none,
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

  void onCheckBoxNewDevice(bool? value) {
    _requestNewDevice = value ?? false;
    _isRequestNewDeviceController.sink.add(_requestNewDevice);
  }

  void onChooseAvailbleDevice(Device? device) {
    if (device != null) {
      _avalbleDevice = device;
      request.deviceId = _avalbleDevice!.id;
      _availbleDeviceController.sink.add(_avalbleDevice);
    }
  }

  void changeErrorStatus(ErrorStatus? status) {
    request.errorStatus = status!;
  }

  void changeDeviceId(Device? device) {
    if (device != null) {
      request.deviceId = device.id;
      _myDevice = device;
    }
  }

  void sendData(String title, String content, Role role) async {
    if (_requestNewDevice) {
      request.errorStatus = ErrorStatus.none;
      if (_avalbleDevice == null) {}
    }

    if (role == Role.leader) {
      request.requestStatus = RequestStatus.approved;
    }
    request.title = title;
    request.content = content;
    RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
        .createRequest(request);
  }

  void dispose() {
    _availbleDeviceController.close();
    _myDeviceManageController.close();
    _isRequestNewDeviceController.close();
  }
}
