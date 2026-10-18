// presentation/widgets/earnings_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';


class EarningsAppBar extends ConsumerWidget {
  const EarningsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider).valueOrNull;
    final online = driver?.isOnline ?? false;
    final initial =
        (driver?.name.isNotEmpty ?? false) ? driver!.name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.field)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.blue, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FLEETRUNNER',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.muted)),
              Text('Completed Orders',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3)),
            ],
          ),
          const Spacer(),
          _PresencePill(online: online),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
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

class _PresencePill extends StatelessWidget {
  const _PresencePill({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    final color = online ? AppColors.green : AppColors.hint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: online
                ? [BoxShadow(color: color, blurRadius: 6, spreadRadius: 1)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(online ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: color)),
      ]),
    );
  }
}