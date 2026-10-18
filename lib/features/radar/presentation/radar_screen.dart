// features/radar/presentation/radar_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as models;
import 'package:rice_delivery/features/orders/orders.dart';
import 'package:rice_delivery/features/radar/presentation/widgets/radar_card.dart';
import 'package:rice_delivery/features/radar/providers/presence_controller.dart';
import 'package:rice_delivery/features/radar/presentation/widgets/radar_app_bar.dart';
import 'package:rice_delivery/features/radar/presentation/widgets/radar_background.dart';
import 'package:rice_delivery/features/radar/providers/radar_orders_provider.dart';
import 'widgets/radar_empty_state.dart';

class RadarScreen extends ConsumerWidget {
  const RadarScreen({super.key});

  static const bool isOnline = true;



  Future<void> _toggle(BuildContext context, WidgetRef ref, bool online) async {
    final ok = await ref.read(presenceControllerProvider.notifier).setOnline(online);
    if (!ok || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(online ? 'You are now ONLINE.' : 'You are now OFFLINE.'),
        backgroundColor: online ? AppColors.green : AppColors.field,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));

    if (isOnline && online) {
      await OrdersSeeder().seedSampleOrders();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sample orders added')));
      }
    }
  }

  Future<void> _accept(BuildContext context, models.Order order) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(order.id).update({
        'status': 'inDelivery',
        'driverId': FirebaseAuth.instance.currentUser?.uid,
        'driverName': FirebaseAuth.instance.currentUser?.displayName ?? 'Driver',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Order for ${order.name} accepted.'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
        ));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not accept the order. Please try again.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(driverProvider).valueOrNull?.isOnline ?? false;
    final busy = ref.watch(presenceControllerProvider).isLoading;

    // Only listen to orders while the driver is online.
    final orders = online
        ? (ref.watch(pendingOrdersProvider).valueOrNull ?? const <models.Order>[])
        : const <models.Order>[];

    ref.listen(presenceControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not change your status. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            RadarAppBar(busy: busy, onToggle: (v) => _toggle(context, ref, v)),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(child: RadarBackground()),
                  if (orders.isEmpty)
                    RadarEmptyState(
                      online: online,
                      busy: busy,
                      onPressed: () => _toggle(context, ref, !online),
                    )
                  else
                    Positioned.fill(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                        itemCount: orders.length + 1,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Text(
                                '${orders.length} ORDER${orders.length == 1 ? '' : 'S'} NEARBY',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: AppColors.green),
                              ),
                            );
                          }
                          final order = orders[i - 1];
                          return RadarOrderCard(
                            order: order,
                            onAccept: () => _accept(context, order),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}