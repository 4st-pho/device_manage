import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';

class DeviceMethod {
  final FirebaseFirestore firebaseFirestore;
  DeviceMethod({
    required this.firebaseFirestore,
  });

  Future<List<Device>> getDeviceByOwnerId(String id) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerId', isEqualTo: id);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getDeviceByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAvailableDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.none.name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<String>> getDeviceIdByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name.trim());
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<String>> getAllDeviceName() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }

  Future<void> createDevice(Device device) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device).doc();
    device.id = doc.id;
    await doc.set(device.toMap());
  }

  Future<void> recallDevice(String id) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device).doc(id);
    doc.update({'ownerId': null, 'ownerType': OwnerType.none.name});
  }

  Future<void> updateDevice(Map<String, dynamic> map) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.device).doc(map['id']);
    doc.update(map);
  }

  Future<void> deleteDevice(String id) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device).doc(id);
    await doc.delete();
  }

  Future<Device> getDevice(String deviceId) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .doc(deviceId.trim());
    final snapshot = await doc.get();
    return Device.fromMap(snapshot.data()!);
  }

  Future<List<Device>> getAllDevice() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllUserDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.user.name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllTeamDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.team.name);
    final snapshot = await doc.get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Stream<List<Device>> streamAlltDevice() {
    return firebaseFirestore
        .collection(AppCollectionPath.device)
        .snapshots()
        .map((snap) => snap.docs.map((e) => Device.fromMap(e.data())).toList());
  }

  Stream<Device> streamDevice(String deviceId) {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .doc(deviceId.trim());
    return doc.snapshots().map((event) => Device.fromMap(event.data()!));
  }

  Stream<List<Device>> streamOwnerDevices(String ownerId) {
    return firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Device.fromMap(e.data())).toList(),
        );
  }

  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final snapshot = await firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerId', isEqualTo: ownerId)
        .get();

    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getListMyDeviveManage(
      String uid, String teamId, Role role) async {
    List<Device> listMyDeviceManage =
        await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getDeviceByOwnerId(uid);
    List<Device> listMyTeamDevice = [];
    if (role == Role.leader) {
      listMyTeamDevice =
          await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
              .getDeviceByOwnerId(teamId);
    }
    listMyDeviceManage.addAll(listMyTeamDevice);
    return listMyDeviceManage;
  }

  Future<List<Device>> getDevicesByName(String name) async {
    final snapshot = await firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name)
        .get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<void> provideDevice({
    required String id,
    required String ownerId,
    required OwnerType ownerType,
  }) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device).doc(id);
    await doc.update({
      'ownerType': ownerType.name,
      'ownerId': ownerId,
    });
  }
}
