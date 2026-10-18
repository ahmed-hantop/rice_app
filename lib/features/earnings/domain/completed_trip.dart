// features/earnings/domain/completed_trip.dart

import 'package:rice_delivery/features/orders/domain/order.dart' as models;

enum DeliveryType { verifiedPod, directHandover }

class CompletedTrip {
  const CompletedTrip({
    required this.order,
    required this.basePay,
    required this.tip,
    required this.distanceKm,
    required this.type,
    this.dockBay,
    this.cargoTag,
  });

  final models.Order order;
  final double basePay, tip, distanceKm;
  final DeliveryType type;
  final String? dockBay;
  final String? cargoTag;

  // Convenience getters from order
  String get id => order.id;
  String get marketName => order.address;
  String get recipientName => order.name;
  String get locationTag => order.address;
  String get pinCode => '';
  double get totalEarnings => order.total.toDouble();
  DateTime get completedAt => order.updatedAt;

  bool get isPod => type == DeliveryType.verifiedPod;
  bool get hasTip => tip > 0;

  /// `completed_at` must already be a DateTime (the data layer converts it),
  /// so the domain stays free of Firebase types.
  factory CompletedTrip.fromMap(String id, Map<String, dynamic> m) {
    double n(String k) => (m[k] as num?)?.toDouble() ?? 0;
    final base = n('base_pay');
    final tip = n('tip');

    // Parse order data from the map
    final order = models.Order.fromMap(id, m);

    return CompletedTrip(
      order: order,
      basePay: base,
      tip: tip,
      distanceKm: n('distance_km'),
      type: m['delivery_type'] == 'direct_handover'
          ? DeliveryType.directHandover
          : DeliveryType.verifiedPod,
      dockBay: m['dock_bay'],
      cargoTag: m['cargo_tag'],
    );
  }

  /// Create a CompletedTrip from an Order with additional trip-specific data
  factory CompletedTrip.fromOrder(
    models.Order order, {
    required double basePay,
    required double tip,
    required double distanceKm,
    required DeliveryType type,
    String? dockBay,
    String? cargoTag,
  }) {
    return CompletedTrip(
      order: order,
      basePay: basePay,
      tip: tip,
      distanceKm: distanceKm,
      type: type,
      dockBay: dockBay,
      cargoTag: cargoTag,
    );
  }
}