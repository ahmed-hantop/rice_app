// // features/delivery/domain/active_delivery.dart
// import 'customer_info.dart';
// import 'market_info.dart';

// class ActiveDelivery {
//   const ActiveDelivery({
//     required this.orderId,
//     required this.routeStatus,
//     required this.etaMinutes,
//     required this.distanceMiles,
//     required this.currentStep,
//     required this.market,
//     required this.customer,
//   });

//   final String orderId, routeStatus;
//   final int etaMinutes;
//   final double distanceMiles;
//   final int currentStep; // 1 = market pickup, 2 = customer drop-off
//   final MarketInfo market;
//   final CustomerInfo customer;

//   bool get isPickupStep => currentStep == 1;

//   factory ActiveDelivery.fromMap(String id, Map<String, dynamic> map) {
//     Map<String, dynamic> sub(String key) =>
//         (map[key] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};

//     return ActiveDelivery(
//       orderId: id,
//       routeStatus: map['route_status'] ?? 'ROUTE IN PROGRESS',
//       etaMinutes: (map['eta_minutes'] as num?)?.toInt() ?? 0,
//       distanceMiles: (map['distance_miles'] as num?)?.toDouble() ?? 0,
//       currentStep: (map['current_step'] as num?)?.toInt() ?? 1,
//       market: MarketInfo.fromMap(sub('market')),
//       customer: CustomerInfo.fromMap(sub('customer')),
//     );
//   }
// }