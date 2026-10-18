// features/delivery/domain/customer_info.dart
class CustomerInfo {
  const CustomerInfo({
    required this.name,
    required this.isContactless,
    required this.orderCode,
    required this.bagCount,
    required this.address,
    required this.gatePin,
    required this.elevator,
    required this.instructions,
    required this.phone,
  });

  final String name, orderCode, address, gatePin, elevator, instructions, phone;
  final bool isContactless;
  final int bagCount;

  factory CustomerInfo.fromMap(Map<String, dynamic> m) => CustomerInfo(
        name: m['name'] ?? '',
        isContactless: m['is_contactless'] ?? false,
        orderCode: m['order_code'] ?? '',
        bagCount: (m['bag_count'] as num?)?.toInt() ?? 0,
        address: m['address'] ?? '',
        gatePin: m['gate_pin'] ?? '',
        elevator: m['elevator'] ?? '',
        instructions: m['instructions'] ?? '',
        phone: m['phone'] ?? '',
      );
}