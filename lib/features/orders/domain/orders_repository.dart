// features/orders/domain/orders_repository.dart
import 'order.dart' as models;

abstract class OrdersRepository {
  /// Accept a pending order and assign it to the driver.
  Future<void> acceptOrder(String orderId, String driverId);

  /// Update order status (e.g., picked_up, delivered, cancelled).
  Future<void> updateOrderStatus(String orderId, models.OrderStatus status);

  /// Cancel an order (with optional reason).
  Future<void> cancelOrder(String orderId, {String? reason});
}
