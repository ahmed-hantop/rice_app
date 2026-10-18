// features/orders/domain/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  inDelivery,
  atMarket,
  pickingUp,
  pickedUp,
  delivering,
  atCustomer,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.accepted,
    );
  }
}

class OrderItem {
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final double price;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String? ?? '',
      quantity: (map['qty'] as num?)?.toInt() ?? 1,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': quantity,
      'price': price,
    };
  }
}

class Order {
  const Order({
    required this.id,
    required this.status,
    required this.address,
    required this.chatId,
    required this.createdAt,
    required this.driverId,
    required this.driverName,
    required this.history,
    required this.notified,
    required this.item,
    required this.itemId,
    required this.lang,
    required this.name,
    required this.number,
    required this.online,
    required this.paymentLabel,
    required this.paymentStatus,
    required this.phone,
    required this.qty,
    required this.source,
    required this.summary,
    required this.time,
    required this.total,
    required this.ts,
    required this.updatedAt,
  });

  final String id;
  final OrderStatus status;
  final String address;
  final String chatId;
  final DateTime createdAt;
  final String driverId;
  final String driverName;
  final List<dynamic> history;
  final bool notified;
  final String item;
  final String itemId;
  final String lang;
  final String name;
  final int number;
  final bool online;
  final String paymentLabel;
  final String paymentStatus;
  final String phone;
  final int qty;
  final String source;
  final String summary;
  final String time;
  final int total;
  final int ts;
  final DateTime updatedAt;

  bool get isPending => status == OrderStatus.pending;
  bool get isAccepted => status == OrderStatus.accepted;
  bool get isInDelivery => status == OrderStatus.inDelivery;
  bool get isAtMarket => status == OrderStatus.atMarket;
  bool get isPickingUp => status == OrderStatus.pickingUp;
  bool get isPickedUp => status == OrderStatus.pickedUp;
  bool get isDelivering => status == OrderStatus.delivering;
  bool get isAtCustomer => status == OrderStatus.atCustomer;
  bool get isDelivered => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isAssigned => driverId.isNotEmpty && driverId != '';
  bool get isCashPayment => paymentLabel.toLowerCase().contains('cash');

  // Convenience getters
  String get customerName => name;
  String get customerPhone => phone;

  // For ItemsCard compatibility
  List<OrderItem> get items => [
        OrderItem(
          name: item,
          quantity: qty,
          price: qty > 0 ? total.toDouble() / qty : 0.0,
        ),
      ];

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    final createdAtTs = map['createdAt'];
    final updatedAtTs = map['updatedAt'];

    return Order(
      id: id,
      status: OrderStatus.fromString(map['status'] as String? ?? 'accepted'),
      address: map['address'] as String? ?? '',
      chatId: map['chatId'] as String? ?? '',
      createdAt: createdAtTs is Timestamp ? createdAtTs.toDate() : DateTime.now(),
      driverId: map['driverId'] as String? ?? '',
      driverName: map['driverName'] as String? ?? '',
      history: map['history'] as List<dynamic>? ?? [],
      notified: map['notified'] as bool? ?? false,
      item: map['item'] as String? ?? '',
      itemId: map['itemId'] as String? ?? '',
      lang: map['lang'] as String? ?? 'en',
      name: map['name'] as String? ?? '',
      number: (map['number'] as num?)?.toInt() ?? 0,
      online: map['online'] as bool? ?? false,
      paymentLabel: map['paymentLabel'] as String? ?? '',
      paymentStatus: map['paymentStatus'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      qty: (map['qty'] as num?)?.toInt() ?? 0,
      source: map['source'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      time: map['time'] as String? ?? '',
      total: (map['total'] as num?)?.toInt() ?? 0,
      ts: (map['ts'] as num?)?.toInt() ?? 0,
      updatedAt: updatedAtTs is Timestamp ? updatedAtTs.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'chatId': chatId,
      'createdAt': Timestamp.fromDate(createdAt),
      'driverId': driverId,
      'driverName': driverName,
      'history': history,
      'notified': notified,
      'status': status.name,
      'ts': ts,
      'item': item,
      'itemId': itemId,
      'lang': lang,
      'name': name,
      'number': number,
      'online': online,
      'paymentLabel': paymentLabel,
      'paymentStatus': paymentStatus,
      'phone': phone,
      'qty': qty,
      'source': source,
      'summary': summary,
      'time': time,
      'total': total,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Order copyWith({
    String? id,
    OrderStatus? status,
    String? address,
    String? chatId,
    DateTime? createdAt,
    String? driverId,
    String? driverName,
    List<dynamic>? history,
    bool? notified,
    String? item,
    String? itemId,
    String? lang,
    String? name,
    int? number,
    bool? online,
    String? paymentLabel,
    String? paymentStatus,
    String? phone,
    int? qty,
    String? source,
    String? summary,
    String? time,
    int? total,
    int? ts,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      address: address ?? this.address,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      history: history ?? this.history,
      notified: notified ?? this.notified,
      item: item ?? this.item,
      itemId: itemId ?? this.itemId,
      lang: lang ?? this.lang,
      name: name ?? this.name,
      number: number ?? this.number,
      online: online ?? this.online,
      paymentLabel: paymentLabel ?? this.paymentLabel,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      phone: phone ?? this.phone,
      qty: qty ?? this.qty,
      source: source ?? this.source,
      summary: summary ?? this.summary,
      time: time ?? this.time,
      total: total ?? this.total,
      ts: ts ?? this.ts,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
