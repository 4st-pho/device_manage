import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class RequestMethod {
  final FirebaseFirestore firebaseFirestore;
  RequestMethod({
    required this.firebaseFirestore,
  });
  Future<void> createRequest(Request request) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.request).doc();
    request.id = doc.id;
    await doc.set(request.toMap());
  }

  Future<Request> getRequest(String deviceId) async {
    final doc =
        firebaseFirestore.collection(AppCollectionPath.device).doc(deviceId);
    final snapshot = await doc.get();
    return Request.fromMap(snapshot.data()!);
  }

  void updateStatusRequest(String id, RequestStatus status) {
    final doc = firebaseFirestore.collection(AppCollectionPath.request).doc(id);
    doc.update({'requestStatus': status.name});
  }

  Stream<List<Request>> streamListRequest(
      String uid, Role role, String teamId) {
    if (role == Role.user) {
      return streamListRequestUser(uid);
    } else if (role == Role.leader) {
      return streamListRequestLeader(teamId);
    }
    return streamListRequestAdmin();
  }

  Future<List<Request>> getAllRequest() async {
    final doc = firebaseFirestore.collection(AppCollectionPath.request);
    final data = await doc.get();
    return data.docs.map((e) => Request.fromMap(e.data())).toList();
  }

  Stream<List<Request>> streamListRequestAdmin() {
    return firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('requestStatus', whereIn: [
          RequestStatus.accept.name,
          RequestStatus.approved.name,
          RequestStatus.reject.name
        ])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }

  Stream<List<Request>> streamListRequestLeader(String teamId) async* {
    List<String> memberIds =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllUserIdSameTeam(teamId);
    memberIds.add(teamId);
    yield* firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('ownerId', whereIn: memberIds)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList());
  }

  Stream<List<Request>> streamListRequestUser(String ownerId) {
    return firebaseFirestore
        .collection(AppCollectionPath.request)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }
}
