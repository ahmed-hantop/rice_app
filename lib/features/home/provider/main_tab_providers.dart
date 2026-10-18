import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom-nav indices on [MainScreen] (v4 four-destination shell).
abstract final class MainTabIndex {
  static const home = 0;
  static const orders = 1;
  static const tasks = 2;
  static const account = 3;


}

/// Inner sections of [MytasksScreen].
abstract final class MytasksSectionIndex {
  static const sessions = 0;
  static const courses = 1;
  static const invitations = 2;
  static const osr = 3;

  /// Legacy alias: former Requests / Activity tab → OSR.
  static const requests = osr;
  static const activity = osr;
}

/// Shared Active / Archived scope values (invitations + OSR APIs).
abstract final class MytasksOsrScope {
  static const active = 'Active';
  static const archived = 'Archived';
}

/// Discover sub-tabs inside [CoursesScreen] (pushed route, not a main tab).
abstract final class DiscoverSectionIndex {
  static const courses = 0;
  static const teachers = 1;
}

/// Main shell bottom-nav tab.
final mainTabIndexProvider = StateProvider<int>((ref) => MainTabIndex.home);

/// My tasks primary tab: sessions (0), courses (1), invitations (2), OSR (3).
final mytasksSectionIndexProvider = StateProvider<int>(
  (ref) => MytasksSectionIndex.sessions,
);

/// Invitations scope under My tasks → Invitations: Active | Archived.
final mytasksInvitationsScopeProvider = StateProvider<String>(
  (ref) => MytasksOsrScope.active,
);

/// OSR scope under My tasks → OSR: Active | Archived.
final mytasksOsrScopeProvider = StateProvider<String>(
  (ref) => MytasksOsrScope.active,
);

/// Discover section: courses (0) or teachers (1).
final discoverSectionIndexProvider = StateProvider<int>(
  (ref) => DiscoverSectionIndex.courses,
);
