// presentation/widgets/receipt_sheet.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/constants/formatter.dart';
import '../../domain/completed_trip.dart';

void showReceiptSheet(BuildContext context, CompletedTrip trip) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Trip Receipt • ${trip.id}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.muted),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            _Row('Market Source', trip.marketName),
            _Row('Customer Destination', '${trip.recipientName} (${trip.locationTag})'),
            _Row('Base Payout', money(trip.basePay)),
            _Row('Customer Tip', money(trip.tip)),
            const Divider(color: AppColors.border),
            _Row('Gross Credited', money(trip.totalEarnings), highlight: true),
          ],
        ),
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.highlight = false});
  final String label, value;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: highlight ? FontWeight.w900 : FontWeight.w700,
                      color: highlight ? AppColors.green : Colors.white)),
            ),
          ],
        ),
      );
}