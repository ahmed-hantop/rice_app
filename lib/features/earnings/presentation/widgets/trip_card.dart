// presentation/widgets/trip_card.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/constants/formatter.dart';
import '../../domain/completed_trip.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});
  final CompletedTrip trip;

  @override
  Widget build(BuildContext context) {
    final accent = trip.isPod ? AppColors.green : AppColors.amber;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: accent.withValues(alpha: 0.35)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(radius: 2.5, backgroundColor: accent),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        trip.isPod
                            ? 'Delivered • Verified POD 📷'
                            : 'Delivered • Direct Handover',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700, color: accent),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              Text('${timeAgo(trip.completedAt)} • ${trip.distanceKm} km',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                const CircleAvatar(radius: 5, backgroundColor: AppColors.amber),
                Container(width: 2, height: 20, color: AppColors.border),
                const CircleAvatar(radius: 5, backgroundColor: AppColors.green),
              ]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(trip.marketName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                    Text(trip.dockBay ?? '',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: Text('${trip.recipientName} (${trip.locationTag})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.soft)),
                    ),
                    Text('Pin ${trip.pinCode}',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700, color: accent)),
                  ]),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}