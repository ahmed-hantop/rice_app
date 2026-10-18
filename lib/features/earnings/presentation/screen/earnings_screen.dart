// presentation/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/earnings/presentation/widgets/filter_pills.dart';
import 'package:rice_delivery/features/earnings/presentation/widgets/trip_card.dart';
import 'package:rice_delivery/features/earnings/providers/earnings_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(completedTripsProvider);
    final ordersAsync = ref.watch(filteredTripsProvider);
    final filter = ref.watch(historyFilterProvider);

    final totalCount = allOrders.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const _OrdersHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrdersSummary(completed: totalCount),
                    const SizedBox(height: 16),
                    FilterPills(
                      selected: filter,
                      totalCount: totalCount,
                      onSelected: (f) =>
                          ref.read(historyFilterProvider.notifier).state = f,
                    ),
                    const SizedBox(height: 16),
                    const _ManifestHeader(),
                    const SizedBox(height: 12),
                    ordersAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: AppColors.green),
                        ),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error loading orders.\n$e',
                            style: const TextStyle(color: AppColors.error)),
                      ),
                      data: (orders) => orders.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text('No completed orders yet.',
                                    style: TextStyle(color: AppColors.muted)),
                              ),
                            )
                          : Column(children: [
                              for (final o in orders) ...[
                                TripCard(trip: o),
                                const SizedBox(height: 12),
                              ],
                            ]),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Orders',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3)),
        ),
      );
}

class _OrdersSummary extends StatelessWidget {
  const _OrdersSummary({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.inventory_2_outlined, color: AppColors.green),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('COMPLETED ORDERS',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted)),
                const SizedBox(height: 2),
                Text('$completed',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ],
            ),
          ],
        ),
      );
}

class _ManifestHeader extends StatelessWidget {
  const _ManifestHeader();

  @override
  Widget build(BuildContext context) => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Verified Orders',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2)),
          Row(children: [
            CircleAvatar(radius: 3, backgroundColor: AppColors.green),
            SizedBox(width: 6),
            Text('LOGGED BY GPS',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.muted)),
          ]),
        ],
      );
}