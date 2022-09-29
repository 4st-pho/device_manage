import 'dart:async';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/user.dart';
import 'package:manage_devices_app/services/clound_firestore/device_service.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';
import 'package:rxdart/rxdart.dart';

class CreateRequestBloc {
  CreateRequestBloc() {
    getAndAddMyDevice();
  }
  Device? _myDevice;
  String _title = '';
  String _content = '';
  ErrorType _errortype = ErrorType.software;

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

  ///  choose available device for request new device
  final _availbleDeviceController = BehaviorSubject<Device?>.seeded(null);
  Stream<Device?> get availbleDeviceStream => _availbleDeviceController.stream;

  /// get data from behaviorSubject
  Device? get availableDevice => _availbleDeviceController.value;
  bool get isLoading => _loadController.value;
  bool get isRequestNewDevice =>
      _isRequestNewDeviceController.valueOrNull ?? false;
  bool get isRequestFromTeam =>
      _isRequestFromTeamController.valueOrNull ?? false;

  ErrorType? get deviceErrorType => _errortype;
  Device? get myDevice => _myDevice;

  void setLoadState(bool loadState) {
    _loadController.add(loadState);
  }

  Future<List<Device>> getAvailableDevice() {
    return DeviceService().getAvailableDevice();
  }

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
      _availbleDeviceController.add(device);
    }
  }

  void onChangeErrorType(ErrorType? errorType) {
    if (errorType != null) {
      _errortype = errorType;
    }
  }

  void onChooseMyDevice(Device? device) {
    if (device != null) {
      _myDevice = device;
    }
  }

  Future<void> sendRequest() async {
    try {
      setLoadState(true);
      if (isRequestNewDevice && availableDevice == null) {
        throw AppString.pleaseChooseDevice;
      }
      User currentUser =
          await SharedPreferencesMethod.getCurrentUserFromLocal();
      final request = Request(
        ownerId: currentUser.id,
        title: _title,
        content: _content,
        errorType: _errortype,
        ownerType: OwnerType.user,
      );
      if (currentUser.role == Role.leader) {
        request.requestStatus = RequestStatus.approved;
      }
      if (isRequestNewDevice) {
        request.errorType = ErrorType.noError;
        request.deviceId = availableDevice!.id;
      } else {
        request.deviceId = _myDevice!.id;
      }
      if (isRequestFromTeam && isRequestNewDevice) {
        request.ownerId = currentUser.teamId;
        request.ownerType = OwnerType.team;
      }
      await RequestService().createRequest(request);
    } catch (e) {
      rethrow;
    } finally {
      setLoadState(false);
    }
  }

  void dispose() {
    _loadController.close();
    _isRequestFromTeamController.close();
    _availbleDeviceController.close();
    _isRequestNewDeviceController.close();
    _myDevicesController.close();
  }
}
