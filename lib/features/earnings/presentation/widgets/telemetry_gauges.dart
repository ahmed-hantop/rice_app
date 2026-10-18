// presentation/widgets/telemetry_gauges.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/features/earnings/domain/shift_metrics.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';



class TelemetryGauges extends StatelessWidget {
  const TelemetryGauges({super.key, required this.metrics});
  final ShiftMetrics metrics;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: _Gauge(
            icon: Icons.explore_outlined,
            color: AppColors.green,
            label: 'ROUTE DISTANCE',
            value: metrics.routeDistanceKm.toStringAsFixed(1),
            unit: 'km',
            unitColor: AppColors.muted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Gauge(
            icon: Icons.eco_outlined,
            color: AppColors.amber,
            label: 'FUEL ECONOMY',
            value: '${metrics.fuelEfficiencyPercent}',
            unit: '% Optimal',
            unitColor: AppColors.green,
          ),
        ),
      ]);
}

class _Gauge extends StatelessWidget {
  const _Gauge({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.unit,
    required this.unitColor,
  });

  final IconData icon;
  final Color color, unitColor;
  final String label, value, unit;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.field,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: AppColors.muted)),
              const SizedBox(height: 2),
              Row(children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(unit,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600, color: unitColor)),
                ),
              ]),
            ]),
          ),
        ]),
      );
}