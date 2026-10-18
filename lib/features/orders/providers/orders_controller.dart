// features/orders/providers/orders_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import '../data/orders_repository_impl.dart';
import '../domain/orders_repository.dart';
import '../domain/order.dart' as models;

final ordersRepositoryProvider = Provider<OrdersRepository>(
  (ref) => OrdersRepositoryImpl(FirebaseFirestore.instance),
);

class OrdersController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Accept a pending order and assign it to the current driver.
  Future<bool> acceptOrder(String orderId) async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(ordersRepositoryProvider).acceptOrder(orderId, uid),
    );
    return !state.hasError;
  }

  /// Update the status of an order (e.g., picked_up, delivered).
  Future<bool> updateStatus(String orderId, models.OrderStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(ordersRepositoryProvider).updateOrderStatus(orderId, status),
    );
    return !state.hasError;
  }

  /// Cancel an order with an optional reason.
  Future<bool> cancelOrder(String orderId, {String? reason}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(ordersRepositoryProvider).cancelOrder(orderId, reason: reason),
    );
    return !state.hasError;
  }
}

final ordersControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrdersController, void>(OrdersController.new);
