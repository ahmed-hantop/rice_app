// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:rice_delivery/features/auth/presnentation/login.dart';
// import 'package:rice_delivery/features/home/provider/main_tab_providers.dart';
// import 'package:rice_delivery/features/home/presentation/widgets/home_bottom_nav_bar.dart';

// class MainScreen extends ConsumerStatefulWidget {
//   /// Thkel-style route name (GoRouter path + name).
//   static const String routeName = '/home';

//   const MainScreen({
//     super.key,
//     this.initialTabIndex,
//     this.initialDiscoverSectionIndex,
//     this.initialLearningSectionIndex,
//   });

//   /// Bottom-nav index: Home, Domains, My Learning, Account.
//   final int? initialTabIndex;

//   /// Discover sub-tab when opening the courses route: 0 courses, 1 teachers.
//   final int? initialDiscoverSectionIndex;

//   /// My Learning section: 0 sessions, 1 courses, 2 invitations, 3 OSR.
//   final int? initialLearningSectionIndex;

//   static int tabIndexFromQuery(String? tab) {
//     switch ((tab ?? '').trim().toLowerCase()) {
    
//       case 'orders':
    
//         return MainTabIndex.orders;
//       case 'tasks':
//         return MainTabIndex.tasks;
    
//       case 'home':
//         // Discover is a pushed route; land on Home and open courses via helpers.
//         return MainTabIndex.home;
//       case 'account':
//         return MainTabIndex.account;
     
//       default:
//         return MainTabIndex.home;
//     }
//   }



//   @override
//   ConsumerState<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends ConsumerState<MainScreen> {
//   bool _didSyncMyChildren = false;

//   static const _screens = <Widget>[
//     DriverLoginScreen(),
//     DriverLoginScreen(),
//     DriverLoginScreen(),
//     DriverLoginScreen(),
//   ];



//   void _changeTab(int index) {
//     final clamped = index.clamp(0, _screens.length - 1);
//     if (ref.read(mainTabIndexProvider) == clamped) return;
//     HapticFeedback.lightImpact();
//     ref.read(mainTabIndexProvider.notifier).state = clamped;
//   }

//   Widget _tabStack(int currentIndex) {
//     return IndexedStack(
//       index: currentIndex.clamp(0, _screens.length - 1),
//       children: _screens,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
  
//     });
//   }

//   @override
//   void didUpdateWidget(covariant MainScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialTabIndex != widget.initialTabIndex ||
//         oldWidget.initialDiscoverSectionIndex !=
//             widget.initialDiscoverSectionIndex ||
//         oldWidget.initialLearningSectionIndex !=
//             widget.initialLearningSectionIndex) {
//    //   _applyInitials();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = ref.watch(mainTabIndexProvider);

//     // Legacy `/?tab=activity|sessions|courses|…` support → providers.
//     final tab = GoRouterState.of(context).uri.queryParameters['tab'];
//     if (tab != null && tab.isNotEmpty) {
     
      
    
//     }

   

//     // Web chrome (drawer) is owned by [WebAppShell]; this screen is tab body only.
//     if (kIsWeb) {
//       return _tabStack(currentIndex);
//     }

//     return Scaffold(
//       extendBody: true,
//       body: _tabStack(currentIndex),
//       bottomNavigationBar: HomeBottomNavBar(
//         currentIndex: currentIndex.clamp(0, _screens.length - 1),
//         onTap: _changeTab,
//       ),
//     );
//   }
// }
