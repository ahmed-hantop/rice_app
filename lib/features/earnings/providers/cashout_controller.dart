// // features/earnings/providers/cashout_controller.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

// import 'earnings_providers.dart';

// class CashoutController extends AutoDisposeAsyncNotifier<void> {
//   @override
//   Future<void> build() async {}

//   /// Returns true when the request was saved.
//   Future<bool> requestCashout() async {
//     final uid = ref.read(authStateProvider).valueOrNull?.uid;
//     if (uid == null) return false;

//     state = const AsyncLoading();
//     state = await AsyncValue.guard(
//       () => ref.read(earningsRepositoryProvider).requestCashout(uid),
//     );
//     return !state.hasError;
//   }
// }

// final cashoutControllerProvider =
//     AutoDisposeAsyncNotifierProvider<CashoutController, void>(CashoutController.new);