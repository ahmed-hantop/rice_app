// features/shell/presentation/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';


class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.radar_rounded, 'Radar'),
    (Icons.local_shipping_rounded, 'Tasks'),
    (Icons.access_time_rounded, 'History'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.navBar,
          border: Border(top: BorderSide(color: AppColors.field)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < _items.length; i++)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: SizedBox(
                      width: 72,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_items[i].$1,
                            size: 24,
                            color: i == currentIndex ? AppColors.green : AppColors.hint),
                        const SizedBox(height: 4),
                        Text(_items[i].$2,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    i == currentIndex ? FontWeight.w700 : FontWeight.w500,
                                color: i == currentIndex
                                    ? AppColors.green
                                    : AppColors.hint)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}