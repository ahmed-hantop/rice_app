
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class ItemsCard extends StatelessWidget {
  const ItemsCard({super.key, required this.items});
  final List<model.OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Icon(Icons.inventory_2_rounded, size: 20, color: AppColors.green),
              const SizedBox(width: 8),
              const Text(
                'ITEMS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.muted,
                ),
              ),
              const Spacer(),
              Text(
                '${items.length} item${items.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${item.price.toStringAsFixed(2)} SAR',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}