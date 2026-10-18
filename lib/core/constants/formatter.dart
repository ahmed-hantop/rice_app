// lib/core/formatters.dart
import 'package:intl/intl.dart';

final _money = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2);

String money(num value) => _money.format(value);

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'just now';
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}