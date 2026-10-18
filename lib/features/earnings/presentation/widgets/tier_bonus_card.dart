// presentation/widgets/tier_bonus_card.dart
import 'package:flutter/material.dart';

import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/constants/formatter.dart';
import '../../domain/shift_metrics.dart';

class TierBonusCard extends StatelessWidget {
  const TierBonusCard({super.key, required this.metrics});
  final ShiftMetrics metrics;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TIER BONUS TARGET',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.muted)),
                Text('${metrics.bonusCurrent} / ${metrics.bonusTarget} deliveries',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: metrics.bonusFraction,
                minHeight: 8,
                backgroundColor: AppColors.field,
                valueColor: const AlwaysStoppedAnimation(AppColors.green),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    metrics.bonusRemaining == 0
                        ? 'Target reached! Bonus of ${money(metrics.bonusReward)} unlocked'
                        : '${metrics.bonusRemaining} more trips to unlock +${money(metrics.bonusReward)} weekend boost',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.soft),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(metrics.bonusFraction * 100).toInt()}% Done',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green)),
              ],
            ),
          ],
        ),
      );
}