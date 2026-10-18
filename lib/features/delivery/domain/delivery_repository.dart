// features/delivery/domain/delivery_repository.dart


import 'package:rice_delivery/features/orders/domain/order.dart' as model;

abstract class DeliveryRepository {
  /// Emits null when the order document does not exist.
  Stream<model.Order?> watchOrder(String orderId);

  Future<void> updateStep(String orderId, int step);

  Future<void> sendSos({required String orderId, required String driverId});
}