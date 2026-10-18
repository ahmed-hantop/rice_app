// presentation/widgets/market_card.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/instruction_box.dart';
import '../../domain/market_info.dart';
import 'icon_action_button.dart';


class MarketCard extends StatelessWidget {
  const MarketCard({
    super.key,
    required this.market,
    required this.onCall,
    required this.onNavigate,
  });

  final MarketInfo market;
  final VoidCallback onCall;
  final VoidCallback? onNavigate; // null when the market has no coordinates

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.4), width: 1.5),
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
                      Text(market.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 6),
                      if (market.orderReadyStatus.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.shopping_bag_outlined,
                                size: 12, color: AppColors.green),
                            const SizedBox(width: 4),
                            Text(market.orderReadyStatus,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.green)),
                          ]),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        'Pickup Code ${market.pickupCode} • ${market.bagCount} Grocery Bags',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                IconActionButton(icon: Icons.call_outlined, size: 42, onTap: onCall),
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
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.green, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(market.address,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Dock: ${market.dockBay}',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green)),
                    ),
                    const SizedBox(width: 10),
                    Text(market.stagingArea,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted)),
                  ]),
                  const SizedBox(height: 10),
                  InstructionsBox(
                    label: 'PICKUP INSTRUCTIONS',
                    text: market.instructions,
                    accent: AppColors.amber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onNavigate,
                icon: const Icon(Icons.navigation_rounded, size: 18),
                label: const Text('Navigate to Market Pickup',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.field,
                  foregroundColor: AppColors.green,
                  elevation: 0,
                  side: BorderSide(color: AppColors.green.withValues(alpha: 0.5), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );
}