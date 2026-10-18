// presentation/widgets/telemetry_banner.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class TelemetryBanner extends StatelessWidget {
  const TelemetryBanner({super.key, required this.order});
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          CircleAvatar(radius: 5, backgroundColor: statusColor),
          const SizedBox(width: 8),
          Text(order.status.name.toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: statusColor)),
        ]),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
          ),
          child: Row(children: [
            Icon(
              order.isCashPayment
                  ? Icons.money_rounded
                  : Icons.credit_card_rounded,
              size: 14,
              color: AppColors.green,
            ),
            const SizedBox(width: 5),
            Text(order.paymentLabel.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green)),
          ]),
        ),
      ],
    );
  }
}