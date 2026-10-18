// features/earnings/data/earnings_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/completed_trip.dart';
import '../domain/earnings_repository.dart';
import '../domain/shift_metrics.dart';
import '../../orders/domain/order.dart' as models;

class EarningsRepositoryImpl implements EarningsRepository {
  EarningsRepositoryImpl(this._db);
  final FirebaseFirestore _db;

  // Cache of order documents so we don't refetch on every snapshot.
  final Map<String, Map<String, dynamic>> _orderCache = {};

  DocumentReference<Map<String, dynamic>> _driver(String id) =>
      _db.collection('drivers').doc(id);

  @override
  Stream<ShiftMetrics> watchMetrics(String driverId) => _driver(driverId)
      .collection('analytics')
      .doc('current_shift')
      .snapshots()
      .map((doc) {
        final data = doc.data();
        return data == null ? ShiftMetrics.empty : ShiftMetrics.fromMap(data);
      });

  @override
  Stream<List<CompletedTrip>> watchCompletedTrips(String driverId,
          {int limit = 50}) =>
      _driver(driverId)
          .collection('completed_orders')
          .orderBy('completed_at', descending: true)
          .limit(limit)
          .snapshots()
          .asyncMap((snap) async {
        final trips = await Future.wait(snap.docs.map(_buildTrip));
        return trips.whereType<CompletedTrip>().toList();
      });

  Future<CompletedTrip?> _buildTrip(
      QueryDocumentSnapshot<Map<String, dynamic>> d) async {
    try {
      final ref = d.data();
      final orderId = (ref['order_id'] as String?) ?? d.id;

      // 1. Load the full order document (cached after first fetch).
      final orderData = await _loadOrder(orderId);
      if (orderData == null) return null; // order was deleted / not found

      // 2. Completion time comes from the completed_orders reference.
      final ts = ref['completed_at'];
      final completedAt = ts is Timestamp ? ts.toDate() : DateTime.now();

      final order = models.Order.fromMap(orderId, {
        ...orderData,
        'updatedAt': completedAt,
      });

      // 3. Trip-specific data: prefer the completed_orders doc, fall back to
      //    the order doc.
      num? pick(String key) => (ref[key] ?? orderData[key]) as num?;
      String? pickStr(String key) => (ref[key] ?? orderData[key]) as String?;

      return CompletedTrip.fromOrder(
        order,
        basePay: pick('base_pay')?.toDouble() ?? 0.0,
        tip: pick('tip')?.toDouble() ?? 0.0,
        distanceKm: pick('distance_km')?.toDouble() ?? 0.0,
        type: ref['delivery_type'] == 'direct_handover'
            ? DeliveryType.directHandover
            : DeliveryType.verifiedPod,
        dockBay: pickStr('dock_bay'),
        cargoTag: pickStr('cargo_tag'),
      );
    } catch (_) {
      return null; // skip malformed entries instead of breaking the stream
    }
  }

  Future<Map<String, dynamic>?> _loadOrder(String orderId) async {
    final cached = _orderCache[orderId];
    if (cached != null) return cached;

    final doc = await _db.collection('orders').doc(orderId).get();
    final data = doc.data();
    if (data != null) _orderCache[orderId] = data;
    return data;
  }
}