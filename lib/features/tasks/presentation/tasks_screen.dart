// features/tasks/presentation/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/orders.dart';

/// Replaced in the claim-order step (assigned and active orders).
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) =>  Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Center(
            child: 
TextButton(
  onPressed: () async {
    await OrdersSeeder().seedSampleOrders();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sample orders added')));
    }
  },
  child: const Text('Add test orders'),
)
          ),
        ),
      );
}