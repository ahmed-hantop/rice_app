// presentation/widgets/arrived_button.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class ArrivedButton extends StatelessWidget {
  const ArrivedButton({super.key, required this.arrived, required this.onPressed});
  final bool arrived;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(arrived ? Icons.check_circle_rounded : Icons.location_on_outlined,
              size: 18, color: arrived ? AppColors.green : AppColors.muted),
          label: Text(
              arrived ? 'Arrived at Customer Location' : 'I Have Arrived at Customer Location',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: arrived ? Colors.white : AppColors.muted)),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.card,
            side: BorderSide(
                color: arrived ? AppColors.green.withOpacity(0.5) : AppColors.border,
                width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}