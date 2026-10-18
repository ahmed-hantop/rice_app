
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: AppColors.muted),
              const SizedBox(height: 12),
              Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
      );
}
