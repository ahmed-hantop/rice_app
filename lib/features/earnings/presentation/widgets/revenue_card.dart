// presentation/widgets/revenue_card.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/constants/formatter.dart';

import '../../domain/shift_metrics.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({
    super.key,
    required this.metrics,
    required this.busy,
    required this.onCashout,
  });

  final ShiftMetrics metrics;
  final bool busy;
  final VoidCallback onCashout;

  @override
  Widget build(BuildContext context) {
    final g = metrics.yieldGrowthPercent;
    final canCashout = metrics.todayYield > 0 && !busy;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TODAY'S REVENUE YIELD",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                            color: AppColors.muted)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(money(metrics.todayYield),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${g >= 0 ? '↗+' : '↘'}${g.toStringAsFixed(1)}%',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: g >= 0 ? AppColors.green : AppColors.error)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('SCHEDULED PAYOUT',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Text(metrics.scheduledPayoutDate,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Cell(Icons.check_circle_outline_rounded, 'Trips', '${metrics.totalTrips}'),
                const _Divider(),
                _Cell(Icons.schedule_rounded, 'Hours', '${metrics.totalHours.toStringAsFixed(1)}h'),
                const _Divider(),
                _Cell(Icons.star_outline_rounded, 'Rating', metrics.driverRating.toStringAsFixed(2)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const CircleAvatar(radius: 3.5, backgroundColor: AppColors.green),
              const SizedBox(width: 6),
              const Text('Available for instant\ndispatch',
                  style: TextStyle(
                      fontSize: 10,
                      height: 1.25,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: canCashout ? onCashout : null,
                icon: busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onGreen))
                    : const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Instant\nCashout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, height: 1.1, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.onGreen,
                  disabledBackgroundColor: AppColors.green.withValues(alpha: 0.35),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.icon, this.label, this.value);
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: AppColors.green),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
      ]);
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 24, color: AppColors.border.withValues(alpha: 0.7));
}