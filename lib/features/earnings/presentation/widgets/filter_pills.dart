// presentation/widgets/filter_pills.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';

import '../../providers/earnings_providers.dart';

class FilterPills extends StatelessWidget {
  const FilterPills({
    super.key,
    required this.selected,
    required this.totalCount,
    required this.onSelected,
  });

  final HistoryFilter selected;
  final int totalCount;
  final ValueChanged<HistoryFilter> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (final f in HistoryFilter.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _Pill(
                  label: f == HistoryFilter.all ? '${f.label} ($totalCount)' : f.label,
                  selected: f == selected,
                  onTap: () => onSelected(f),
                ),
              ),
          ],
        ),
      );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : AppColors.field,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: selected ? AppColors.green : AppColors.border.withValues(alpha: 0.6)),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.onGreen : AppColors.muted)),
        ),
      );
}