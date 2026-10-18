// features/radar/presentation/widgets/radar_empty_state.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';


class RadarEmptyState extends StatelessWidget {
  const RadarEmptyState({
    super.key,
    required this.online,
    required this.busy,
    required this.onPressed,
  });

  final bool online, busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Target(online: online),
            const SizedBox(height: 32),
            Text(online ? 'Scanning for Orders' : 'No Orders Active',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: Colors.white)),
            const SizedBox(height: 14),
            Text(
              online
                  ? 'You are online. New market delivery orders near you will appear here.'
                  : 'You are currently offline. Switch your status to Online to start scanning for nearby market delivery orders.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, height: 1.5, color: AppColors.muted.withValues(alpha: 0.9)),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: busy ? null : onPressed,
                icon: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onGreen))
                    : const Icon(Icons.power_settings_new_rounded, size: 22),
                label: Text(online ? 'GO OFFLINE' : 'GO ONLINE',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: online ? AppColors.field : AppColors.green,
                  foregroundColor: online ? AppColors.muted : AppColors.onGreen,
                  disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
                  elevation: 0,
                  side: online ? const BorderSide(color: AppColors.border) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Target extends StatelessWidget {
  const _Target({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    final color = online ? AppColors.green : AppColors.muted;
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.field,
        border: Border.all(
            color: online ? AppColors.green.withValues(alpha: 0.5) : AppColors.border, width: 3),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.radar_rounded, size: 44, color: color),
          Positioned(
            top: 22,
            right: 22,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online ? AppColors.green : AppColors.hint,
                border: Border.all(color: AppColors.field, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}