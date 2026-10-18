// features/delivery/presentation/widgets/order_items_sheet.dart
import 'package:flutter/material.dart';

import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

/// Returns true when the driver confirmed the items, otherwise null/false.
Future<bool?> showOrderItemsSheet(BuildContext context, model.Order order) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _OrderItemsSheet(order: order),
  );
}

class _OrderItemsSheet extends StatefulWidget {
  const _OrderItemsSheet({required this.order});
  final model.Order order;

  @override
  State<_OrderItemsSheet> createState() => _OrderItemsSheetState();
}

class _OrderItemsSheetState extends State<_OrderItemsSheet> {
  late final List<bool> _picked = List.filled(widget.order.items.length, false);

  int get _count => _picked.where((p) => p).length;

  @override
  Widget build(BuildContext context) {
    final items = widget.order.items;
    final total = items.length;
    final allPicked = _count == total;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scroll) => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(children: [
                const Icon(Icons.shopping_basket_outlined,
                    color: AppColors.green, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Items',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text('$_count of $total picked',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : _count / total,
                  minHeight: 6,
                  backgroundColor: AppColors.field,
                  valueColor: const AlwaysStoppedAnimation(AppColors.green),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text('No items listed for this order.',
                          style: TextStyle(color: AppColors.muted)))
                  : ListView.separated(
                      controller: scroll,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount: total,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _ItemTile(
                        item: items[i],
                        picked: _picked[i],
                        onTap: () => setState(() => _picked[i] = !_picked[i]),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // ONLY returns true. The caller opens the camera.
                  onPressed: allPicked ? () => Navigator.of(context).pop(true) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.onGreen,
                    disabledBackgroundColor: AppColors.green.withValues(alpha: 0.3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('CONFIRM & TAKE PICTURE ($_count/$total)',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item, required this.picked, required this.onTap});
  final dynamic item; // your OrderItem type: change `dynamic` to it if you want
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final q = item.quantity as num;
    final qty = q % 1 == 0 ? q.toInt().toString() : q.toString();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: picked
                  ? AppColors.green.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.7)),
        ),
        child: Row(children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: picked ? AppColors.green : AppColors.bg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: picked ? AppColors.green : AppColors.hint),
            ),
            child: picked
                ? const Icon(Icons.check_rounded, size: 16, color: AppColors.onGreen)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('${item.name}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: picked ? AppColors.muted : Colors.white,
                    decoration: picked ? TextDecoration.lineThrough : null)),
          ),
          Text('x$qty',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green)),
        ]),
      ),
    );
  }
}