// features/orders/data/orders_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/orders_repository.dart';
import '../domain/order.dart' as models;

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._db);
  final FirebaseFirestore _db;

  @override
  Future<void> acceptOrder(String orderId, String driverId) async {
    await _db.collection('orders').doc(orderId).update({
      'status': 'accepted',
      'driverId': driverId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateOrderStatus(String orderId, models.OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelOrder(String orderId, {String? reason}) async {
    final updates = <String, dynamic>{
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (reason != null) {
      updates['cancellationReason'] = reason;
    }
    await _db.collection('orders').doc(orderId).update(updates);
  }
}
