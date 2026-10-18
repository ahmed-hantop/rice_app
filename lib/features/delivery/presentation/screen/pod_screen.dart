// presentation/pod_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/services/launcher_service.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/arrived_button.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/customer_card.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/delivery_app_bar.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/pod_card.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/support_footer.dart';
import 'package:rice_delivery/features/delivery/providers/delivery_action_controller.dart';
import 'package:rice_delivery/features/delivery/providers/pod_form_controller.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;



class PodScreen extends ConsumerWidget {
  const PodScreen({super.key, required this.order,required this.imagePath});
  final model.Order order;
  final String imagePath;

  void _snack(BuildContext context, String msg, {bool error = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.error : AppColors.green,
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(podFormProvider);
    final ctrl = ref.read(podFormProvider.notifier);
    final launcher = ref.read(launcherServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            DeliveryAppBar(
              title: 'Proof Of Delivery',
              onSos: () {
                ref.read(deliveryActionsProvider.notifier).sendSos(order.id);
                _snack(context, 'Emergency SOS sent to dispatch.');
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomerCard(
                      customer: order,
                      onCall: () => launcher.call(order.phone),
                      onSms: () => launcher.sms(order.phone),
                    ),
                    const SizedBox(height: 12),
                    ArrivedButton(arrived: form.arrived, onPressed: ctrl.toggleArrived),
                    const SizedBox(height: 16),
                    PodCard(
                      form: form,
                      imagePath: imagePath,
                      
                      // onCapture: () async {
                      //   final err = await ctrl.takePhoto();
                      //   if (err != null && context.mounted) _snack(context, err);
                      //},
                      onNotes: ctrl.setNotes,
                      onToggleTemp: ctrl.toggleTempOk,
                      onToggleSms: ctrl.toggleSmsNotified,
                      onSubmit: () async {
                        final err = await ctrl.submit(order.id);
                        if (!context.mounted) return;
                        if (err != null) {
                          _snack(context, err);
                        } else {
                          _snack(context, 'Proof submitted. Delivery complete.',
                              error: false);
                          context.go('/radar');
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    const SupportFooter(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}