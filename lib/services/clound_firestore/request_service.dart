import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/enums/request_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/user_service.dart';

class RequestService {
  final requestCollection =
      FirebaseFirestore.instance.collection(AppCollectionPath.request);

  /// create request
  Future<void> createRequest(Request request) async {
    final requestDoc = requestCollection.doc();
    request.id = requestDoc.id;
    await requestDoc.set(request.toMap());
  }

  /// get request
  Future<Request> getRequest(String id) async {
    final requestDoc = requestCollection.doc(id);
    final snapshot = await requestDoc.get();
    return Request.fromMap(snapshot.data()!);
  }

  /// update request stataus
  Future<void> updateRequestStatus(String id, RequestStatus status) async {
    final requestDoc = requestCollection.doc(id);
    await requestDoc.update({'requestStatus': status.name});
  }

  /// delete requests for device
  Future<void> deleteRequestsForDevice(String deviceId) async {
    final requestDoc = await requestCollection
        .where('deviceId', isEqualTo: deviceId.trim())
        .get();
    requestDoc.docs.map((e) {
      e.data()['id'];
      requestCollection.doc(e.data()['id']).delete();
    });
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
    final data = await requestCollection.get();
    return data.docs.map((e) => Request.fromMap(e.data())).toList();
  }

  Stream<Request> streamRequest(String id) {
    return requestCollection
        .doc(id)
        .snapshots()
        .map((e) => Request.fromMap(e.data()!));
  }

// get stream list request admin
  Stream<List<Request>> streamListRequestAdmin() {
    return requestCollection
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
    List<String> memberIds = await UserService().getAllUserIdSameTeam(teamId);
    memberIds.add(teamId);
    yield* requestCollection
        .where('ownerId', whereIn: memberIds)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList());
  }

  /// stream list request user
  Stream<List<Request>> streamListRequestUser(String ownerId) {
    return requestCollection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Request.fromMap(e.data())).toList(),
        );
  }
}
