import 'package:cloud_firestore/cloud_firestore.dart';

/// Wraps Firestore initialization + persistence settings.
/// Call [FirestoreService.enableOfflinePersistence] once in main() before runApp.
class FirestoreService {
  FirestoreService._();

  static void enableOfflinePersistence() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  static FirebaseFirestore get instance => FirebaseFirestore.instance;
}
