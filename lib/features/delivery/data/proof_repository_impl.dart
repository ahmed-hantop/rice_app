// features/delivery/data/proof_repository_impl.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/proof_repository.dart';
import '../domain/proof_submission.dart';

class ProofRepositoryImpl implements ProofRepository {
  ProofRepositoryImpl(this._db, this._storage);
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  @override
  Future<void> submit(ProofSubmission p) async {
    // 1. Upload the photo
    final ref = _storage.ref(
      'pod_photos/${p.driverId}/${p.orderId}/pod_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(File(p.photoPath), SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();

    // 2. Save the proof. The doc id is the order id, so there is one proof per order
    //    and the rules can forbid overwriting it.
    await _db.collection('proof_of_deliveries').doc(p.orderId).set({
      'order_id': p.orderId,
      'driver_id': p.driverId,
      'photo_url': url,
      'dropoff_notes': p.notes,
      'is_temp_checked': p.tempOk,
      'is_sms_notified': p.smsNotified,
      'location': GeoPoint(p.location.lat, p.location.lng),
      'submitted_at': FieldValue.serverTimestamp(),
    });
  }
}