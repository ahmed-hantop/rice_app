// features/delivery/providers/delivery_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/delivery/data/delivery_repo_implement.dart';
import 'package:rice_delivery/features/delivery/domain/delivery_repository.dart';

import 'package:rice_delivery/features/orders/domain/order.dart' as model;

final deliveryRepositoryProvider = Provider<DeliveryRepository>(
  (ref) => DeliveryRepositoryImpl(FirebaseFirestore.instance),
);

/// Live order, by order id.
final orderProvider =
    StreamProvider.autoDispose.family<model.Order?, String>(
  (ref, orderId) => ref.watch(deliveryRepositoryProvider).watchOrder(orderId),
);