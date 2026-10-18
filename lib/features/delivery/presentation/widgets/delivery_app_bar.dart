// presentation/widgets/delivery_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

class DeliveryAppBar extends ConsumerWidget {
  const DeliveryAppBar({super.key, required this.onSos, this.title = 'Active Delivery'});
final VoidCallback onSos;
final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(driverProvider).valueOrNull?.name ?? '';
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.field)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.canPop() ? context.pop() : null,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.blue, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Text('Active Delivery',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3)),
          const Spacer(),
          InkWell(
            onTap: onSos,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.error, borderRadius: BorderRadius.circular(8)),
              child: const Text('SOS',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.8)),
            ),
          ),
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