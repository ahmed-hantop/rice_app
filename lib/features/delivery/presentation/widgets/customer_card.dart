// presentation/widgets/customer_card.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;
import 'icon_action_button.dart';
import 'instruction_box.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.onCall,
    required this.onSms,
  });

  final model.Order customer;
  final VoidCallback onCall, onSms;

  @override
  Widget build(BuildContext context) => Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                          child: Text(customer.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                      ]),
                      const SizedBox(height: 6),
                      Text(
                        'Order #${customer.number} • ${customer.qty} Items',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                IconActionButton(icon: Icons.call_outlined, onTap: onCall),
                const SizedBox(width: 8),
                IconActionButton(icon: Icons.chat_bubble_outline_rounded, onTap: onSms),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.field,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(customer.address,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InstructionsBox(
                    label: 'INSTRUCTIONS',
                    text: customer.summary,
                    accent: AppColors.muted,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}