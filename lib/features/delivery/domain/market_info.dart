// features/delivery/domain/market_info.dart
class MarketInfo {
  const MarketInfo({
    required this.name,
    required this.orderReadyStatus,
    required this.pickupCode,
    required this.bagCount,
    required this.address,
    required this.dockBay,
    required this.stagingArea,
    required this.instructions,
    required this.phone,
    this.latitude,
    this.longitude,
  });

  final String name, orderReadyStatus, pickupCode, address;
  final String dockBay, stagingArea, instructions, phone;
  final int bagCount;
  final double? latitude, longitude;

  factory MarketInfo.fromMap(Map<String, dynamic> m) => MarketInfo(
        name: m['name'] ?? '',
        orderReadyStatus: m['order_ready_status'] ?? '',
        pickupCode: m['pickup_code'] ?? '',
        bagCount: (m['bag_count'] as num?)?.toInt() ?? 0,
        address: m['address'] ?? '',
        dockBay: m['dock_bay'] ?? '',
        stagingArea: m['staging_area'] ?? '',
        instructions: m['instructions'] ?? '',
        phone: m['phone'] ?? '',
        latitude: (m['latitude'] as num?)?.toDouble(),
        longitude: (m['longitude'] as num?)?.toDouble(),
      );
}