// presentation/widgets/icon_action_button.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';


class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.green, size: 18),
        ),
      );
}