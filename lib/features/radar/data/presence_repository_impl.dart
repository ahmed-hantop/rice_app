// features/radar/data/presence_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/presence_repository.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  PresenceRepositoryImpl(this._db);
  final FirebaseFirestore _db;

    @override
    Future<void> setOnline(String driverId, bool online) =>
        _db.collection('drivers').doc(driverId).set({
  'isOnline': online,
  'lastSeen': FieldValue.serverTimestamp(),
}, SetOptions(merge: true));
}