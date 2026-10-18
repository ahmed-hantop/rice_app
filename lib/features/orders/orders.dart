// File: lib/features/orders/data/orders_seeder.dart
// NOTE: This file is deprecated and no longer matches the Firebase schema.
// Orders are now created from WhatsApp/integration sources with different structure.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'domain/order.dart' as models;

class OrdersSeeder {
  OrdersSeeder([FirebaseFirestore? db]) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');

  /// Creates one order and returns its document id.
  /// Leave [driverId] null for an unassigned order drivers can pick up.
  Future<String> createOrder({
    required String customerName,
    required String customerPhone,
    required String pickupAddress,
    required GeoPoint pickupLocation,
    required String dropoffAddress,
    required GeoPoint dropoffLocation,
    required List<models.OrderItem> items,
    required double total,
    String paymentLabel = 'Cash on delivery',
    models.OrderStatus status = models.OrderStatus.accepted,
    String? driverId,
  }) async {
    final doc = _orders.doc(); // auto id, so we can store it inside the document
    final order = models.Order(
      id: doc.id,
      status: status,
      driverId: driverId ?? '',
      address: dropoffAddress,
      chatId: '',
      createdAt: DateTime.now(),
      driverName: '',
      history: [],
      notified: false,
      item: items.isNotEmpty ? items.first.name : '',
      itemId: '',
      lang: 'en',
      name: customerName,
      number: 0,
      online: false,
      paymentLabel: paymentLabel,
      paymentStatus: 'unpaid',
      phone: customerPhone,
      qty: items.fold(0, (total, i) => total + i.quantity),
      source: 'app',
      summary: '',
      time: '',
      total: total.toInt(),
      ts: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now(),
    );
    await doc.set({
      ...order.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Adds sample orders around Dammam for testing. Call it once.
  Future<void> seedSampleOrders() async {
    final samples = [
      (
        'Mohammed Ali',
        '+966501112222',
        'Al Rice House, Al Faisaliyah',
        const GeoPoint(26.4207, 50.0888),
        'Al Shatea District, Building 12',
        const GeoPoint(26.4486, 50.1103),
        [
          const models.OrderItem(name: 'Basmati Rice 5kg', quantity: 2, price: 45.0),
          const models.OrderItem(name: 'Sunflower Oil 1.5L', quantity: 1, price: 18.0),
        ],
        108.0,
      ),
      (
        'Sara Ahmed',
        '+966503334444',
        'Al Rice House, Al Faisaliyah',
        const GeoPoint(26.4207, 50.0888),
        'Al Aziziyah District, Villa 7',
        const GeoPoint(26.3927, 50.0610),
        [
          const models.OrderItem(name: 'Jasmine Rice 10kg', quantity: 1, price: 85.0),
        ],
        85.0,
      ),
      (
        'Khaled Noor',
        '+966505556666',
        'Al Rice House, Al Faisaliyah',
        const GeoPoint(26.4207, 50.0888),
        'Al Khobar, Corniche Street 3',
        const GeoPoint(26.2794, 50.2083),
        [
          const models.OrderItem(name: 'Brown Rice 2kg', quantity: 3, price: 22.0),
        ],
        66.0,
      ),
    ];

    for (final s in samples) {
      await createOrder(
        customerName: s.$1,
        customerPhone: s.$2,
        pickupAddress: s.$3,
        pickupLocation: s.$4,
        dropoffAddress: s.$5,
        dropoffLocation: s.$6,
        items: s.$7,
        total: s.$8,
      );
    }
  }
}