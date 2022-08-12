// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethos {
  final FirebaseStorage firebaseStorage;
  StorageMethos({
    required this.firebaseStorage,
  });

  Future<String> uploadAndGetImageLink(
    String childName,
    File file,
  ) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(DateTime.now().toIso8601String());
    TaskSnapshot snap = await ref.putFile(file);
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
