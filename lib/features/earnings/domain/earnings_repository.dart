// features/earnings/domain/earnings_repository.dart
import 'completed_trip.dart';
import 'shift_metrics.dart';

abstract class EarningsRepository {
  Stream<ShiftMetrics> watchMetrics(String driverId);
  Stream<List<CompletedTrip>> watchCompletedTrips(String driverId, {int limit = 50});

  /// Asks the server to pay out the driver's available balance.
  /// The client never sends an amount.
 // Future<void> requestCashout(String driverId);
}