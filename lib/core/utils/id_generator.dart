import 'package:cloud_firestore/cloud_firestore.dart';

/// Generates Firestore-safe document IDs offline.
/// Firestore's .doc() (no arg) generates a unique ID locally
/// without needing a server round-trip — critical for offline-first writes.
class IdGenerator {
  IdGenerator._();

  static String newId(String collectionPath) {
    return FirebaseFirestore.instance.collection(collectionPath).doc().id;
  }
}
