
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, 
    required this.icon,
    required this.label,
    required this.address,
    required this.location,
    required this.hasCoords,
    this.onNavigate,
  });

  final IconData icon;
  final String label;
  final String address;
  final dynamic location;
  final bool hasCoords;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: [
              Icon(icon, size: 20, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.muted,
                ),
              ),
              const Spacer(),
              if (hasCoords && onNavigate != null)
                IconButton(
                  icon: const Icon(Icons.navigation_rounded, size: 20),
                  color: AppColors.green,
                  onPressed: onNavigate,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
