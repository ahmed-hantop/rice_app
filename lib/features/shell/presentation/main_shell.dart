// features/shell/presentation/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'widgets/app_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bg,
        body: shell,
        bottomNavigationBar: AppBottomNav(
          currentIndex: shell.currentIndex,
          // tapping the active tab returns to that tab's first screen
          onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        ),
      );
}