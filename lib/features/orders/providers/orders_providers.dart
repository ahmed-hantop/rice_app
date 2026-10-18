// features/orders/providers/orders_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as models;

/// Stream of all orders assigned to the current driver.
final driverOrdersProvider = StreamProvider.autoDispose<List<models.Order>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const []);

  return FirebaseFirestore.instance
      .collection('orders')
      .where('driverId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return models.Order.fromMap(doc.id, data);
          }).toList());
});

/// Stream of active orders for the current driver (accepted, inDelivery, atMarket, pickingUp, pickedUp, delivering, or atCustomer).
final activeOrdersProvider = StreamProvider.autoDispose<List<models.Order>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null || uid.isEmpty) return Stream.value(const []);

  return FirebaseFirestore.instance
      .collection('orders')
      .where('driverId', isEqualTo: uid)
      .where('status', whereIn: ['accepted', 'inDelivery', 'atMarket', 'pickingUp', 'pickedUp', 'delivering', 'atCustomer'])
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return models.Order.fromMap(doc.id, data);
          }).toList());
});

/// Stream of completed orders for the current driver.
final completedOrdersProvider = StreamProvider.autoDispose<List<models.Order>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const []);

  return FirebaseFirestore.instance
      .collection('orders')
      .where('driverId', isEqualTo: uid)
      .where('status', isEqualTo: 'delivered')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return models.Order.fromMap(doc.id, data);
          }).toList());
});

/// Get a single order by ID as a stream.
final orderByIdProvider = StreamProvider.family.autoDispose<models.Order?, String>((ref, orderId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;
        return models.Order.fromMap(doc.id, doc.data()!);
      });
});
