import 'dart:async';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/enums/error_status.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';
import 'package:rxdart/rxdart.dart';

class CreateRequestBloc {
  CreateRequestBloc() {
    getAndAddMyDevice();
  }
  Device? _myDevice;
  Device? _availableDevice;
  String _title = '';
  String _content = '';
  ErrorStatus _errorStatus = ErrorStatus.software;

  /// choose request new device or my request my device manage
  final _isRequestNewDeviceController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isRequestNewDeviceStream =>
      _isRequestNewDeviceController.stream;

  ///  choose request from team or user
  final _isRequestFromTeamController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isRequestFromTeamStream =>
      _isRequestFromTeamController.stream;

  /// control list my device (only my device)
  final _myDevicesController = BehaviorSubject<List<Device>>.seeded([]);
  Stream<List<Device>> get myDevicesStream => _myDevicesController.stream;

  /// control load state
  final _loadController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadStream => _loadController.stream;
  bool get isLoading => _loadController.value;

  void toggleState() {
    _loadController.add(!isLoading);
  }

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  final _nameAvailbleDeviceController = BehaviorSubject<String?>.seeded(null);
  Stream<String?> get availbleDeviceStream =>
      _nameAvailbleDeviceController.stream;

  Device? get myDevide => _myDevice;
  ErrorStatus? get deviceErrorStatus => _errorStatus;

  bool get isRequestNewDevice =>
      _isRequestNewDeviceController.valueOrNull ?? false;

  bool get isRequestFromTeam =>
      _isRequestFromTeamController.valueOrNull ?? false;
  void onTitleChange(String? title) {
    if (title != null) {
      _title = title.trim();
    }
  }

  Future<void> getAndAddMyDevice() async {
    final listDevice = await DeviceService().getListMyDeviveManage();
    _myDevicesController.add(listDevice);
  }

  void onContentChange(String? content) {
    if (content != null) {
      _content = content;
    }
  }

  void onCheckNewDevice(bool? value) {
    if (value != null) {
      _isRequestNewDeviceController.add(value);
    }
  }

  void onCheckRequestFromTeam(bool? value) {
    if (value != null) {
      _isRequestFromTeamController.add(value);
    }
  }

  void onChooseAvailbleDevice(Device? device) {
    if (device != null) {
      _availableDevice = device;
      _nameAvailbleDeviceController.add(device.name);
    }
  }

  void onChangeErrorStatus(ErrorStatus? errorStatus) {
    if (errorStatus != null) {
      _errorStatus = errorStatus;
    }
  }

  void onChooseMyDevice(Device? device) {
    if (device != null) {
      _myDevice = device;
    }
  }

  bool validateAvailbleDevice() {
    final isNotValidAvailbleDevice =
        isRequestNewDevice && _availableDevice == null;
    if (isNotValidAvailbleDevice) {
      return false;
    }
    return true;
  }

  Future<void> sendRequest() async {
    setLoadState(true);
    User currentUser = await SharedPreferencesMethod.getCurrentUserFromLocal();
    final request = Request(
      ownerId: currentUser.id,
      title: _title,
      content: _content,
      errorStatus: _errorStatus,
      ownerType: OwnerType.user,
    );
    if (isRequestNewDevice) {
      request.errorStatus = ErrorStatus.noError;
      request.deviceId = _availableDevice!.id;
    } else {
      request.deviceId = _myDevice!.id;
    }
    if (isRequestFromTeam && isRequestNewDevice) {
      request.ownerId = currentUser.teamId;
      request.ownerType = OwnerType.team;
    }
    await RequestService().createRequest(request).catchError((error) {
      setLoadState(false);
      throw error;
    });
  }

  void dispose() {
    _loadController.close();
    _isRequestFromTeamController.close();
    _nameAvailbleDeviceController.close();
    _isRequestNewDeviceController.close();
    _myDevicesController.close();
  }
}
