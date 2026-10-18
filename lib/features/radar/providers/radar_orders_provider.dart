// features/radar/providers/radar_orders_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as models;

/// Stream of pending orders (unassigned) that drivers can accept.
final pendingOrdersProvider = StreamProvider.autoDispose<List<models.Order>>((ref) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('status', isEqualTo: 'accepted')
      .where('driverId', isEqualTo: '')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return models.Order.fromMap(doc.id, data);
          }).toList());
});
