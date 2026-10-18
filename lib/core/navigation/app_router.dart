// app/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/features/auth/presnentation/driver_login.dart';
import 'package:rice_delivery/features/auth/presnentation/otp_screen.dart';
import 'package:rice_delivery/features/auth/presnentation/splash.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'package:rice_delivery/features/delivery/presentation/screen/active_delivery_screen.dart';
import 'package:rice_delivery/features/delivery/presentation/screen/pod_screen.dart';
import 'package:rice_delivery/features/earnings/presentation/screen/earnings_screen.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;
import 'package:rice_delivery/features/orders/providers/orders_providers.dart';
import 'package:rice_delivery/features/profile/presentation/profile_screen.dart';
import 'package:rice_delivery/features/radar/presentation/radar_screen.dart';
import 'package:rice_delivery/features/shell/presentation/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final loc = state.matchedLocation;

      if (auth.isLoading) return '/splash';

      // Signed out: only login and OTP are allowed
      if (auth.valueOrNull == null) {
        return (loc == '/login' || loc == '/otp') ? null : '/login';
      }

      // Signed in: keep them out of the auth screens
      if (const {'/login', '/otp', '/splash'}.contains(loc)) return '/radar';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const DriverLoginScreen()),
      GoRoute(path: '/otp', builder: (_, _) => const OtpScreen()),
      GoRoute(
        path: '/order/:id',
        builder: (_, s) {
          final order = s.extra as model.Order?;
          if (order == null) {
            return const Scaffold(
              body: Center(child: Text('No Orders')),
            );
          }
          return ActiveDeliveryScreen(order: order);
        },
      ),
 GoRoute(
  path: '/order-pod',
  builder: (_, state) {
    final order = state.extra as model.Order?;
    if (order == null) {
      // happens after a hot restart or when the app is restored
      return const Scaffold(body: Center(child: Text('Order data missing.')));
    }
    return PodScreen(order: order, imagePath: '');
  },
),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/radar', builder: (_, _) => const RadarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/orders', builder: (_, _) => const _ActiveDeliveryWrapper()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/history', builder: (_, _) => const OrdersScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});

class _ActiveDeliveryWrapper extends ConsumerWidget {
  const _ActiveDeliveryWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrders = ref.watch(activeOrdersProvider);

    return activeOrders.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        debugPrint('Error loading active orders: $error');
        debugPrint('Stack trace: $stack');

        final errorMsg = error.toString();
        final isIndexError = errorMsg.contains('FAILED_PRECONDITION') || errorMsg.contains('requires an index');

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Error loading orders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  if (isIndexError) ...[
                    const Text(
                      'A Firestore index needs to be created. Please click the link below to create it automatically.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'https://console.firebase.google.com/v1/r/project/rice-driver-app/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9yaWNlLWRyaXZlci1hcHAvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL29yZGVycy9pbmRleGVzL18QARoMCghkcml2ZXJJZBABGgoKBnN0YXR1cxABGg0KCWNyZWF0ZWRBdBACGgwKCF9fbmFtZV9fEAI',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ] else
                    Text(
                      errorMsg,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        );
      },
      data: (orders) {
        if (orders.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No Active Orders')),
          );
        }
        // Show the first active order
        return ActiveDeliveryScreen(order: orders.first);
      },
    );
  }
}