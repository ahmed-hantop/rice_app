// import 'package:flutter/material.dart';
// import 'package:rice_delivery/core/widgets/app_text.dart';
// import 'package:rice_delivery/core/widgets/home_v4_colors.dart';

// /// Single destination in the compact four-tab bottom navigation.
// class HomeBottomNavItem extends StatelessWidget {
//   const HomeBottomNavItem({
//     super.key,
//     required this.index,
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });

//   final int index;
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     final labelColor = isActive ? HomeV4Colors.navy : HomeV4Colors.navInactive;
//     final iconColor = isActive ? HomeV4Colors.teal : HomeV4Colors.navInactive;

//     return InkWell(
//       onTap: () => onTap(index),
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       borderRadius: BorderRadius.circular(16),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         curve: Curves.easeOut,
//         margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//         decoration: BoxDecoration(
//           color: isActive ? HomeV4Colors.navActiveBg : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 22, color: iconColor),
//             const SizedBox(height: 2),
//             AppText(
//               text: label,
//               maxLine: 1,
//               overflow: TextOverflow.ellipsis,
//               softWrap: false,
//               fontSize: 11,
//               textHeight: 1.0,
//               fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
//               color: labelColor,
//               align: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
