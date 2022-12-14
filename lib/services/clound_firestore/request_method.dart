import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/helper/show_snackbar.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/init/init_data.dart';

class RequestMethod {
  final FirebaseFirestore firebaseFirestore;
  RequestMethod({
    required this.firebaseFirestore,
  });
  Future<void> createRequest(Request request, BuildContext context) async {
    try {
      final doc = firebaseFirestore.collection(AppCollectionPath.request).doc();
      request.id = doc.id;
      await doc.set(request.toMap());
      showSnackBar(context: context, content: 'Request has been sent');
    } catch (e) {
      showSnackBar(
          context: context, content: e.toString(), title: 'Error', error: true);
    }
  }

  Future<Request> getRequest(String deviceId) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.device).doc(deviceId);
    final snapshot = await doc.get();
    return Request.fromMap(snapshot.data()!);
  }

  void updateStatusRequest(
      String id, RequestStatus status, BuildContext context) {
    try {
      final doc =
          firebaseFirestore.collection(AppCollectionPath.request).doc(id);
      doc.update({'requestStatus': status.name});
      showSnackBar(
        context: context,
        content: 'Update successfully',
        title: 'Update Request',
      );
    } catch (e) {
      showSnackBar(
          context: context, content: e.toString(), title: 'Error', error: true);
    }
    Navigator.of(context).pop();
  }

  Stream<List<Request>> streamListRequest() {
    if (currentUser!.role == Role.user) {
      return streamListRequestUser();
    } else if (currentUser!.role == Role.leader) {
      return streamListRequestLeader();
    }
    return streamListRequestAdmin();
  }

  Stream<List<Request>> streamListRequestAdmin() {
    return firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('requestStatus', whereIn: [
          RequestStatus.accept.name,
          RequestStatus.approved.name,
          RequestStatus.refuse.name
        ])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }

  Stream<List<Request>> streamListRequestLeader() {
    List<String> menderId = teamMember.map((e) => e.id).toList();
    return firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('uid', whereIn: menderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList());
  }

  Stream<List<Request>> streamListRequestUser() {
    return firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('uid', isEqualTo: currentUser!.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }
}
