// presentation/widgets/quality_checkbox.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class QualityCheckbox extends StatelessWidget {
  const QualityCheckbox({
    super.key,
    required this.label,
    required this.sublabel,
    required this.checked,
    required this.onTap,
  });

  final String label, sublabel;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: checked
                    ? AppColors.green.withOpacity(0.5)
                    : AppColors.border.withOpacity(0.7)),
          ),
          child: Row(children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? AppColors.green : AppColors.bg,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: checked ? AppColors.green : AppColors.hint),
              ),
              child: checked
                  ? const Icon(Icons.check_rounded, size: 15, color: AppColors.onGreen)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                Text(sublabel,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted)),
              ]),
            ),
          ]),
        ),
      );
}