// presentation/widgets/support_footer.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class SupportFooter extends StatelessWidget {
  const SupportFooter({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emergency_outlined, size: 14, color: AppColors.error),
          const SizedBox(width: 5),
          Text('Safety Hotline',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error.withOpacity(0.9))),
          const SizedBox(width: 16),
          const CircleAvatar(radius: 2, backgroundColor: AppColors.hint),
          const SizedBox(width: 16),
          const Icon(Icons.headset_mic_outlined, size: 14, color: AppColors.muted),
          const SizedBox(width: 5),
          const Text('Courier Dispatch Support',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
        ],
      );
}