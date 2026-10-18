
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/services/launcher_service.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/customer_card.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/items_card.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/location_card.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/status_card.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class Body extends StatelessWidget {
  const Body({super.key,
    required this.order,
    required this.launcher,
    required this.onLaunch,
    this.isAccepting = false,
  });

  final model.Order order;
  final LauncherService launcher;
  final void Function(Future<bool>) onLaunch;
  final bool isAccepting;

  @override
  Widget build(BuildContext context) {
    final children = [
      // Market Section
      _SectionHeader(title: 'MARKET'),
      const SizedBox(height: 12),
      StatusCard(order: order),
      const SizedBox(height: 16),
      LocationCard(
        icon: Icons.storefront_rounded,
        label: 'PICKUP',
        address: order.address,
        location: null,
        hasCoords: false,
        onNavigate: null,
      ),
      const SizedBox(height: 16),
      ItemsCard(items: [
        model.OrderItem(name: order.item, quantity: order.qty, price: order.total.toDouble() / order.qty),
      ]),
      const SizedBox(height: 24),

      // Customer Section
      _SectionHeader(title: 'CUSTOMER'),
      const SizedBox(height: 12),
      CustomerCard(
        onCall: () => onLaunch(launcher.call(order.phone)),
        onSms: () => onLaunch(launcher.sms(order.phone)),
        customer: order,
      ),
      const SizedBox(height: 16),
      LocationCard(
        icon: Icons.location_on_rounded,
        label: 'DROP-OFF',
        address: order.address,
        location: null,
        hasCoords: false,
        onNavigate: null,
      ),
      const SizedBox(height: 24),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildListDelegate(children),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppColors.muted,
      ),
    );
  }
}
