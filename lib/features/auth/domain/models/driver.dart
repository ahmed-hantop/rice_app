// domain/driver.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.zone,
    required this.isApproved,
    required this.isOnline,
  });

  final String id, name, phone, zone;
  final bool isApproved, isOnline;

  factory Driver.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Driver(
      
      id: doc.id,
      name: d['name'] ?? '',
      phone: d['phone'] ?? '',
      zone: d['zone'] ?? '',
      isApproved: d['isApproved'] ?? false,
      isOnline: d['isOnline'] ?? false,
    );
  }
}