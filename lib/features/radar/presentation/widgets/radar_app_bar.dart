// features/radar/presentation/widgets/radar_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

class RadarAppBar extends ConsumerWidget {
  const RadarAppBar({super.key, required this.busy, required this.onToggle});
  final bool busy;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider).valueOrNull;
    final online = driver?.isOnline ?? false;
    final initial =
        (driver?.name.isNotEmpty ?? false) ? driver!.name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.field)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: AppColors.blue, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FLEETRUNNER',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.muted)),
              Text('Map Radar',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: online ? AppColors.green.withValues(alpha: 0.3) : AppColors.border),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? AppColors.green : AppColors.hint,
                  boxShadow: online
                      ? const [
                          BoxShadow(color: AppColors.green, blurRadius: 6, spreadRadius: 1)
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 6),
              Text(online ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: online ? AppColors.green : AppColors.muted)),
              const SizedBox(width: 6),
              Transform.scale(
                scale: 0.65,
                child: Switch(
                  value: online,
                  onChanged: busy ? null : onToggle,
                  activeThumbColor: AppColors.green,
                  inactiveThumbColor: AppColors.muted,
                  inactiveTrackColor: const Color(0xFF1E293B),
                ),
              ),
            ]),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 19,
            backgroundColor: AppColors.field,
            child: Text(initial,
                style: const TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}