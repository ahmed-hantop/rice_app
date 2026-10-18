// // not_approved_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

// class NotApprovedScreen extends ConsumerWidget {
//   const NotApprovedScreen({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Your account is not active yet.\nPlease contact dispatch.',
//                   textAlign: TextAlign.center),
//               const SizedBox(height: 16),
//               OutlinedButton(
//                 onPressed: () => ref.read(authRepositoryProvider).signOut(),
//                 child: const Text('Sign out'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }