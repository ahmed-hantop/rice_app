// features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

import '../../radar/providers/presence_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driver?.name ?? '',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              Text(driver?.phone ?? '', style: const TextStyle(color: AppColors.muted)),
              Text('Zone: ${driver?.zone ?? ''}',
                  style: const TextStyle(color: AppColors.muted)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                  onPressed: () async {
                    // Go offline first, so dispatch never sees a signed-out driver as online.
                    if (driver?.isOnline ?? false) {
                      await ref.read(presenceControllerProvider.notifier).setOnline(false);
                    }
                    await ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}