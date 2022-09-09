import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class RequestService {
  final deviceCollection =
      FirebaseFirestore.instance.collection(AppCollectionPath.request);

  /// create request
  Future<void> createRequest(Request request) async {
    final deviceDoc = deviceCollection.doc();
    request.id = deviceDoc.id;
    await deviceDoc.set(request.toMap());
  }

  /// get request
  Future<Request> getRequest(String id) async {
    final deviceDoc = deviceCollection.doc(id);
    final snapshot = await deviceDoc.get();
    return Request.fromMap(snapshot.data()!);
  }

// update request stataus
  void updateRequestStatus(String id, RequestStatus status) {
    final deviceDoc = deviceCollection.doc(id);
    deviceDoc.update({'requestStatus': status.name});
  }

  /// stream list request by name
  Stream<List<Request>> streamListRequest(
      String uid, Role role, String teamId) {
    if (role == Role.user) {
      return streamListRequestUser(uid);
    } else if (role == Role.leader) {
      return streamListRequestLeader(teamId);
    }
    return streamListRequestAdmin();
  }

  /// get all request
  Future<List<Request>> getAllRequest() async {
    final data = await deviceCollection.get();
    return data.docs.map((e) => Request.fromMap(e.data())).toList();
  }

// get stream list request admin
  Stream<List<Request>> streamListRequestAdmin() {
    return deviceCollection
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

  /// get stream list request leader
  Stream<List<Request>> streamListRequestLeader(String teamId) async* {
    List<String> memberIds =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllUserIdSameTeam(teamId);
    memberIds.add(teamId);
    yield* deviceCollection
        .where('ownerId', whereIn: memberIds)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList());
  }

  /// stream list request user
  Stream<List<Request>> streamListRequestUser(String ownerId) {
    return deviceCollection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }
}
