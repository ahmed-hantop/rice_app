// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}



// Temporary, replaced in the next step
class HomePlaceholder extends ConsumerWidget {
  const HomePlaceholder({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${driver?.name ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: const Center(child: Text('Home')),
    );
  }
}