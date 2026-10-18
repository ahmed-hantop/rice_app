// features/delivery/providers/delivery_actions_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'delivery_providers.dart';

/// Driver actions (step change, SOS) with loading/error state.
class DeliveryActionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateStep(String orderId, int step) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deliveryRepositoryProvider).updateStep(orderId, step),
    );
  }

  Future<void> sendSos(String orderId) async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return;
    state = await AsyncValue.guard(
      () => ref
          .read(deliveryRepositoryProvider)
          .sendSos(orderId: orderId, driverId: uid),
    );
  }
}

final deliveryActionsProvider =
    AutoDisposeAsyncNotifierProvider<DeliveryActionsController, void>(
  DeliveryActionsController.new,
);