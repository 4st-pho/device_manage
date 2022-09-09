import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/model/device.dart';

class DeviceService {
  final deviceCollection =
      FirebaseFirestore.instance.collection(AppCollectionPath.device);

  Future<List<Device>> getDeviceByOwnerId(String id) async {
    final deviceDoc = deviceCollection.where('ownerId', isEqualTo: id);
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getDeviceByName(String name) async {
    final deviceDoc = deviceCollection.where('name', isEqualTo: name);
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAvailableDevice() async {
    final deviceDoc =
        deviceCollection.where('ownerType', isEqualTo: OwnerType.none.name);
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<String>> getDeviceIdByName(String name) async {
    final deviceDoc = deviceCollection.where('name', isEqualTo: name.trim());
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<String>> getAllDeviceName() async {
    final deviceDoc = deviceCollection;
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }

  Future<void> createDevice(Device device) async {
    final deviceDoc = deviceCollection.doc();
    device.id = deviceDoc.id;
    await deviceDoc.set(device.toMap());
  }

  Future<void> recallDevice(String id) async {
    final deviceDoc = deviceCollection.doc(id);
    deviceDoc.update({'ownerId': null, 'ownerType': OwnerType.none.name});
  }

  Future<void> updateDevice(Map<String, dynamic> map) async {
    final deviceDoc = deviceCollection.doc(map['id']);
    deviceDoc.update(map);
  }

  Future<void> updateDeviceData(
      String deviceId, Map<String, dynamic> data) async {
    final deviceDoc = deviceCollection.doc(deviceId);
    deviceDoc.update(data);
  }

  Future<void> deleteDevice(String id) async {
    final deviceDoc = deviceCollection.doc(id);
    await deviceDoc.delete();
  }

  Future<Device> getDevice(String deviceId) async {
    final deviceDoc = deviceCollection.doc(deviceId.trim());
    final snapshot = await deviceDoc.get();
    return Device.fromMap(snapshot.data()!);
  }

  Future<List<Device>> getAllDevice() async {
    final deviceDoc = deviceCollection;
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllUserDevice() async {
    final deviceDoc =
        deviceCollection.where('ownerType', isEqualTo: OwnerType.user.name);
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllTeamDevice() async {
    final deviceDoc =
        deviceCollection.where('ownerType', isEqualTo: OwnerType.team.name);
    final snapshot = await deviceDoc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Stream<List<Device>> streamAlltDevice() {
    return deviceCollection
        .snapshots()
        .map((snap) => snap.docs.map((e) => Device.fromMap(e.data())).toList());
  }

  Stream<Device> streamDevice(String deviceId) {
    final deviceDoc = deviceCollection.doc(deviceId.trim());
    return deviceDoc.snapshots().map((event) => Device.fromMap(event.data()!));
  }

  Stream<List<Device>> streamOwnerDevices(String ownerId) {
    return deviceCollection
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Device.fromMap(e.data())).toList(),
        );
  }

  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final snapshot =
        await deviceCollection.where('ownerId', isEqualTo: ownerId).get();

    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getListMyDeviveManage() async {
    final currentUser = await SharedPreferencesMethod.getCurrentUserFromLocal();
    List<Device> listMyDeviceManage = await getDeviceByOwnerId(currentUser.id);
    List<Device> listMyTeamDevice = [];
    if (currentUser.role == Role.leader) {
      listMyTeamDevice = await getDeviceByOwnerId(currentUser.teamId);
    }
    listMyDeviceManage.addAll(listMyTeamDevice);
    return listMyDeviceManage;
  }

  Future<List<Device>> getDevicesByName(String name) async {
    final snapshot =
        await deviceCollection.where('name', isEqualTo: name).get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<void> provideDevice({
    required String id,
    required String ownerId,
    required OwnerType ownerType,
  }) async {
    final deviceDoc = deviceCollection.doc(id);
    await deviceDoc.update({
      'ownerType': ownerType.name,
      'ownerId': ownerId,
    });
  }
}
