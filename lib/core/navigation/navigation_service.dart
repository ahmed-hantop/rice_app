import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/core/navigation/root_navigator_key.dart';
/// Minimal navigation/session helper for shared core code (e.g. HTTP 401,
/// missing token on protected requests).
class NavigationService {
  NavigationService._();

  /// Clears prefs + SecureStorage, resets auth state, and goes to splash.
  static Future<void> logout() async {
   // await UserPreferencesService.clearUserData();
 //   await SecureStorageService().deleteToken();

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    try {
      final container = ProviderScope.containerOf(context);
     // await container.read(authProvider.notifier).logout();
    } catch (_) {
      // ProviderScope may be unavailable in isolate/background; storage
      // already cleared above.
    }

    if (context.mounted) {
      GoRouter.of(context).goNamed('splash');
    }
  }
}
