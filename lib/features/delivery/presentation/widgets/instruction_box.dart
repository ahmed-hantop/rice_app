// presentation/widgets/instructions_box.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class InstructionsBox extends StatelessWidget {
  const InstructionsBox({
    super.key,
    required this.label,
    required this.text,
    required this.accent,
  });

  final String label, text;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 15, color: accent),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w800, color: accent),
                  ),
                  TextSpan(
                    text: text,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.muted, height: 1.35),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
}