// features/radar/providers/presence_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

import '../data/presence_repository_impl.dart';
import '../domain/presence_repository.dart';

final presenceRepositoryProvider = Provider<PresenceRepository>(
  (ref) => PresenceRepositoryImpl(FirebaseFirestore.instance),
);

class PresenceController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns true when Firestore accepted the change.
  Future<bool> setOnline(bool online) async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return false;

    // Step 7 adds the location-permission check here, before going online.
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(presenceRepositoryProvider).setOnline(uid, online),
    );
    return !state.hasError;
  }
}

final presenceControllerProvider =
    AutoDisposeAsyncNotifierProvider<PresenceController, void>(PresenceController.new);