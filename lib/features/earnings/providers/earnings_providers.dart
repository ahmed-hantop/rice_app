// features/earnings/providers/earnings_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

import '../data/earnings_repository_impl.dart';
import '../domain/completed_trip.dart';
import '../domain/earnings_repository.dart';
import '../domain/shift_metrics.dart';

final earningsRepositoryProvider = Provider<EarningsRepository>(
  (ref) => EarningsRepositoryImpl(FirebaseFirestore.instance),
);

final _driverIdProvider = Provider<String?>(
  (ref) => ref.watch(authStateProvider).valueOrNull?.uid,
);

final shiftMetricsProvider = StreamProvider.autoDispose<ShiftMetrics>((ref) {
  final uid = ref.watch(_driverIdProvider);
  if (uid == null) return Stream.value(ShiftMetrics.empty);
  return ref.watch(earningsRepositoryProvider).watchMetrics(uid);
});

final completedTripsProvider = StreamProvider.autoDispose<List<CompletedTrip>>((ref) {
  final uid = ref.watch(_driverIdProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(earningsRepositoryProvider).watchCompletedTrips(uid);
});

// ───────────────────────── Filters ─────────────────────────

enum HistoryFilter {
  all('All Trips'),
  today('Today'),
  thisWeek('This Week'),
  marketRuns('Market Runs');

  const HistoryFilter(this.label);
  final String label;

  List<CompletedTrip> apply(List<CompletedTrip> trips) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    // Saudi week starts on Sunday (DateTime.weekday: Mon=1 ... Sun=7)
    final startOfWeek = startOfDay.subtract(Duration(days: now.weekday % 7));

    switch (this) {
      case HistoryFilter.all:
        return trips;
      case HistoryFilter.today:
        return trips.where((t) => !t.completedAt.isBefore(startOfDay)).toList();
      case HistoryFilter.thisWeek:
        return trips.where((t) => !t.completedAt.isBefore(startOfWeek)).toList();
      case HistoryFilter.marketRuns:
        // Your original never defined this tab. Placeholder rule:
        // trips that carried special cargo. Change it to your definition.
        return trips.where((t) => t.cargoTag != null).toList();
    }
  }
}

final historyFilterProvider =
    StateProvider.autoDispose<HistoryFilter>((_) => HistoryFilter.all);

/// Trips after the selected filter is applied.
final filteredTripsProvider = Provider.autoDispose<AsyncValue<List<CompletedTrip>>>((ref) {
  final filter = ref.watch(historyFilterProvider);
  return ref.watch(completedTripsProvider).whenData(filter.apply);
});