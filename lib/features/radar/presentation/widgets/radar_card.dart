// features/radar/presentation/widgets/radar_order_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/widgets/app_button.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as models;

class RadarOrderCard extends StatelessWidget {
  const RadarOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
  });

  final models.Order order;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final itemCount = order.qty;

    return GestureDetector(
      onTap: (){
        context.push('/order/${order.id}', extra: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(order.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.field,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
                  ),
                  child: Text('${order.total} SAR',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _AddressRow(
                icon: Icons.storefront_rounded,
                label: 'PICKUP',
                text: order.address),
            const SizedBox(height: 10),
            _AddressRow(
                icon: Icons.location_on_rounded,
                label: 'DROP-OFF',
                text: order.address),
            const SizedBox(height: 12),
            Text(
              '$itemCount items  •  ${order.paymentLabel}',
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            AppButton(onAccept: onAccept, title: 'Accept Order'),
          ],
        ),
      ),
    );
  }
}


class _AddressRow extends StatelessWidget {
  const _AddressRow(
      {required this.icon, required this.label, required this.text});
  final IconData icon;
  final String label, text;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(text,
                    style: const TextStyle(
                        fontSize: 13, height: 1.35, color: Colors.white)),
              ],
            ),
          ),
        ],
      );
}