// presentation/widgets/step_tracker.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class StepTracker extends StatelessWidget {
  const StepTracker({super.key, required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _StepTile(
                number: 1,
                title: 'Market Pickup',
                icon: Icons.store_rounded,
                active: currentStep == 1,
              ),
            ),
            Container(
              width: 24,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: AppColors.border,
            ),
            Expanded(
              child: _StepTile(
                number: 2,
                title: 'Customer Drop-off',
                icon: Icons.local_shipping_rounded,
                active: currentStep == 2,
              ),
            ),
          ],
        ),
      );
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.number,
    required this.title,
    required this.icon,
    required this.active,
  });

  final int number;
  final String title;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: active ? AppColors.green : AppColors.field,
            ),
            child: Icon(icon,
                size: 18, color: active ? AppColors.onGreen : AppColors.muted),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(active ? 'Step $number • Active' : 'Step $number',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: active ? AppColors.green : AppColors.muted)),
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      );
}