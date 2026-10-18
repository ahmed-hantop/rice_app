import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onAccept,
    required this.title,
    this.isLoading = false,
  });

  final VoidCallback onAccept;
  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : onAccept,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.onGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.onGreen),
                ),
              )
            : Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6)),
      ),
    );
  }
}