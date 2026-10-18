// features/delivery/data/delivery_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/delivery_repository.dart';


import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class DeliveryRepositoryImpl implements DeliveryRepository {
  DeliveryRepositoryImpl(this._db);
  final FirebaseFirestore _db;

  @override
  Stream<model.Order?> watchOrder(String orderId) =>
      _db.collection('orders').doc(orderId).snapshots().map((doc) {
        final data = doc.data();
        if (!doc.exists || data == null) return null;
        return model.Order.fromMap(doc.id, data);
      });

  @override
  Future<void> updateStep(String orderId, int step) =>
      _db.collection('orders').doc(orderId).update({
        'current_step': step,
        'updated_at': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> sendSos({required String orderId, required String driverId}) =>
      _db.collection('Orders').add({
        'order_id': orderId,
        'driver_id': driverId,
        'severity': 'HIGH_SOS',
        'timestamp': FieldValue.serverTimestamp(),
      });
}