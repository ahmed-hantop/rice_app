// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:rice_delivery/core/localization/app_strings.dart';
// import 'package:rice_delivery/core/widgets/home_v4_colors.dart';
// import 'package:rice_delivery/core/widgets/home_v4_layout.dart';
// import 'package:rice_delivery/features/home/provider/main_tab_providers.dart';
// import 'package:rice_delivery/features/home/presentation/widgets/home_bottom_nav_item.dart';

// /// Compact four-destination bottom navigation (reference v4).
// class HomeBottomNavBar extends StatelessWidget {
//   const HomeBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   /// Prefer [HomeV4Layout.bottomNavHeight]; kept for call-site compatibility.
//   static const double barHeight = HomeV4Layout.bottomNavHeight;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.94),
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(color: HomeV4Colors.softBorder),
//               boxShadow: [
//                 BoxShadow(
//                   color: HomeV4Colors.navy.withValues(alpha: 0.08),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: SizedBox(
//               height: HomeV4Layout.bottomNavHeight - 8,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: HomeBottomNavItem(
//                       index: MainTabIndex.home,
//                       icon: Icons.home_rounded,
//                       label: AppStrings.home.tr(),
//                       isActive: currentIndex == MainTabIndex.home,
//                       onTap: onTap,
//                     ),
//                   ),
//                   Expanded(
//                     child: HomeBottomNavItem(
//                       index: MainTabIndex.orders,
//                       icon: Icons.grid_view_rounded,
//                       label: AppStrings.navDomains.tr(),
//                       isActive: currentIndex == MainTabIndex.orders,
//                       onTap: onTap,
//                     ),
//                   ),
//                   Expanded(
//                     child: HomeBottomNavItem(
//                       index: MainTabIndex.tasks,
//                       icon: Icons.menu_book_rounded,
//                       label: AppStrings.navMyLearning.tr(),
//                       isActive: currentIndex == MainTabIndex.tasks,
//                       onTap: onTap,
//                     ),
//                   ),
//                   Expanded(
//                     child: HomeBottomNavItem(
//                       index: MainTabIndex.account,
//                       icon: Icons.person_rounded,
//                       label: AppStrings.navMyAccount.tr(),
//                       isActive: currentIndex == MainTabIndex.account,
//                       onTap: onTap,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
