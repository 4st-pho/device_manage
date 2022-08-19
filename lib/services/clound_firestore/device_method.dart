import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/owner_type.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/device.dart';

class DeviceMethod {
  final FirebaseFirestore firebaseFirestore;
  DeviceMethod({
    required this.firebaseFirestore,
  });

  Future<List<Device>> getDeviceById(String id) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerId', isEqualTo: id);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getDeviceByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAvailableDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.none.name);
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<String>> getDeviceIdByName(String name) async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name.trim());
    final snapshot = await doc.get();
    return snapshot.docs.map((e) => e.data()['id'] as String).toList();
  }

  Future<List<String>> getAllDeviceName() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.device);
    final value = await doc.get();
    return value.docs.map((e) => e.data()['name'] as String).toList();
  }

  Future<void> createDevice(BuildContext context, Device device) async {
    try {
      final doc = firebaseFirestore.collection(AppCollectionPath.device).doc();
      device.id = doc.id;
      await doc.set(device.toMap());
      showSnackBar(context: context, content: 'Create succes!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  Future<void> recallDevice(BuildContext context, String id) async {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.device).doc(id);
      doc.update({'ownerId': null, 'ownerType': OwnerType.none.name});
      showSnackBar(context: context, content: 'Recall device success!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  Future<void> updateDevice(
      BuildContext context, Map<String, dynamic> map) async {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.device).doc(map['id']);
      doc.update(map);
      showSnackBar(context: context, content: 'Update success!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
  }

  Future<void> deleteDevice(BuildContext context, String id) async {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.device).doc(id);
      await doc.delete();
      showSnackBar(context: context, content: 'Deleted!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString(), error: true);
    }
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
    final value = await doc.get();
    return value.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllUserDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.user.name);
    final value = await doc.get();
    return value.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getAllTeamDevice() async {
    final doc = firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerType', isEqualTo: OwnerType.team.name);
    final value = await doc.get();
    return value.docs.map((e) => Device.fromMap(e.data())).toList();
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
    final devices = await firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('ownerId', isEqualTo: ownerId)
        .get();
    return devices.docs.map((e) => Device.fromMap(e.data())).toList();
  }

  Future<List<Device>> getDevicesByName(String name) async {
    final devices = await firebaseFirestore
        .collection(AppCollectionPath.device)
        .where('name', isEqualTo: name)
        .get();
    return devices.docs.map((e) => Device.fromMap(e.data())).toList();
  }
}
