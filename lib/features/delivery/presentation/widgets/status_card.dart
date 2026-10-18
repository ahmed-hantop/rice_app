
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.order});
  final model.Order order;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (order.status) {
      model.OrderStatus.pending => AppColors.amber,
      model.OrderStatus.accepted => AppColors.blue,
      model.OrderStatus.inDelivery => AppColors.blue,
      model.OrderStatus.atMarket => AppColors.amber,
      model.OrderStatus.pickingUp => AppColors.amber,
      model.OrderStatus.pickedUp => AppColors.green,
      model.OrderStatus.delivering => AppColors.blue,
      model.OrderStatus.atCustomer => AppColors.green,
      model.OrderStatus.delivered => AppColors.green,
      model.OrderStatus.cancelled => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              order.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Order #${order.id}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
          Text(
            '${order.total} SAR',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

