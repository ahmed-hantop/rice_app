// features/earnings/domain/shift_metrics.dart
class ShiftMetrics {
  const ShiftMetrics({
    required this.todayYield,
    required this.yieldGrowthPercent,
    required this.scheduledPayoutDate,
    required this.totalTrips,
    required this.totalHours,
    required this.driverRating,
    required this.routeDistanceKm,
    required this.fuelEfficiencyPercent,
    required this.bonusCurrent,
    required this.bonusTarget,
    required this.bonusReward,
  });

  /// Used when the analytics document does not exist yet.
  static const empty = ShiftMetrics(
    todayYield: 0,
    yieldGrowthPercent: 0,
    scheduledPayoutDate: '—',
    totalTrips: 0,
    totalHours: 0,
    driverRating: 0,
    routeDistanceKm: 0,
    fuelEfficiencyPercent: 0,
    bonusCurrent: 0,
    bonusTarget: 0,
    bonusReward: 0,
  );

  final double todayYield, yieldGrowthPercent, totalHours, driverRating;
  final double routeDistanceKm, bonusReward;
  final String scheduledPayoutDate;
  final int totalTrips, fuelEfficiencyPercent, bonusCurrent, bonusTarget;

  bool get hasBonus => bonusTarget > 0;
  double get bonusFraction =>
      hasBonus ? (bonusCurrent / bonusTarget).clamp(0.0, 1.0) : 0;
  int get bonusRemaining => (bonusTarget - bonusCurrent).clamp(0, bonusTarget);

  factory ShiftMetrics.fromMap(Map<String, dynamic> m) => ShiftMetrics(
        todayYield: (m['today_yield'] as num?)?.toDouble() ?? 0,
        yieldGrowthPercent: (m['yield_growth_percent'] as num?)?.toDouble() ?? 0,
        scheduledPayoutDate: m['scheduled_payout_date'] ?? '—',
        totalTrips: (m['total_trips'] as num?)?.toInt() ?? 0,
        totalHours: (m['total_hours'] as num?)?.toDouble() ?? 0,
        driverRating: (m['driver_rating'] as num?)?.toDouble() ?? 0,
        routeDistanceKm: (m['route_distance_km'] as num?)?.toDouble() ?? 0,
        fuelEfficiencyPercent: (m['fuel_efficiency_percent'] as num?)?.toInt() ?? 0,
        bonusCurrent: (m['bonus_current'] as num?)?.toInt() ?? 0,
        bonusTarget: (m['bonus_target'] as num?)?.toInt() ?? 0,
        bonusReward: (m['bonus_reward'] as num?)?.toDouble() ?? 0,
      );
}