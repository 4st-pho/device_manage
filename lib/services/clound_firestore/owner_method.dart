import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manage_devices_app/constants/app_collection_path.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class OwnerMethod {
  final FirebaseFirestore firebaseFirestore;
  OwnerMethod({
    required this.firebaseFirestore,
  });

  Future<Map<String, dynamic>> getOwnerInfo(String id) async {
    final doc = firebaseFirestore.collection(AppCollectionPath.user).doc(id);
    final snapshot = await doc.get();
    if (snapshot.data() == null || snapshot.data()!.isEmpty) {
      final team =
          await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
              .getTeam(id);
      return {
        'type': 'team',
        'data': team,
      };
    } else {
      final user =
          await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
              .getUser(id);
      return {
        'type': 'user',
        'data': user,
      };
    }
  }
}
