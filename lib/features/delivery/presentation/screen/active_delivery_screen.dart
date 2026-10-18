// presentation/active_delivery_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/navigation/app_routes.dart';
import 'package:rice_delivery/core/widgets/app_button.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/active_delivery_body.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/order_item_bottom_sheet.dart';
import 'package:rice_delivery/features/delivery/providers/delivery_action_controller.dart';
import 'package:rice_delivery/features/delivery/presentation/widgets/delivery_app_bar.dart';
import 'package:rice_delivery/features/delivery/presentation/screen/pickup_submission_screen.dart';
import 'package:rice_delivery/features/delivery/presentation/screen/complete_dleivery_screen.dart';
import 'package:rice_delivery/core/services/launcher_service.dart';
import 'package:rice_delivery/features/delivery/providers/delivery_providers.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class ActiveDeliveryScreen extends ConsumerStatefulWidget {
  const ActiveDeliveryScreen({super.key, required this.order});
  final model.Order order;

  @override
  ConsumerState<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends ConsumerState<ActiveDeliveryScreen> {
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  void _snack(BuildContext context, String msg, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _launch(BuildContext context, Future<bool> action) async {
    final ok = await action;
    if (!ok && context.mounted) _snack(context, 'Could not open the app.');
  }

  Future<void> _updateStatus(String status) async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.order.id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      _snack(context, 'Status updated successfully', error: false);
    } catch (_) {
      if (!mounted) return;
      _snack(context, 'Could not update status. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _startDelivery() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.order.id).update({
        'status': 'inDelivery',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      if (mounted) _snack(context, 'Status updated successfully', error: false);

      // Open Google Maps to address
      final launcher = ref.read(launcherServiceProvider);
      await launcher.navigateToAddress(widget.order.address);
    } catch (_) {
      if (!mounted) return;
      if (mounted) _snack(context, 'Could not update status. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _arriveToMarket() async {
    await _updateStatus('atMarket');
  }
Future<void> _startPickUp() async {
  final current = ref.read(orderProvider(widget.order.id)).valueOrNull ?? widget.order;

  if (!current.isPickingUp) {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .update({'status': 'pickingUp', 'updatedAt': FieldValue.serverTimestamp()});
    } catch (_) {
      if (!mounted) return;
      _snack(context, 'Could not update status. Please try again.');
      return;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  if (!mounted) return;
  final confirmed = await showOrderItemsSheet(context, current);
  if (confirmed != true || !mounted) return;

  await _capturePickupPhoto(current);
}

Future<void> _capturePickupPhoto(model.Order current) async {
  final status = await Permission.camera.request();
  if (!mounted) return;
  if (!status.isGranted) {
    _snack(context, 'Camera permission is required to capture the picked items');
    if (status.isPermanentlyDenied) openAppSettings();
    return;
  }

  final XFile? photo =
      await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);
  if (!mounted) return;
  if (photo == null) {
    _snack(context, 'Photo capture cancelled');
    return;
  }

  await Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => PickupSubmissionScreen(
      order: current,
      photo: photo,
      title: 'Pickup Proof',
      onSubmit: _submitPickup,
    ),
  ));
}

/// Throws on failure so PickupSubmissionScreen shows the error and stays open.
Future<void> _submitPickup(String description) async {
  await FirebaseFirestore.instance
      .collection('orders')
      .doc(widget.order.id)
      .update({
    'status': 'pickedUp',
    'pickupDescription': description,
    'updatedAt': FieldValue.serverTimestamp(),
  });
  debugPrint('PICKUP: writing pickedUp for ${widget.order.id}');
}

  Future<void> _startDelivering() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.order.id).update({
        'status': 'delivering',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      if (mounted) _snack(context, 'Status updated successfully', error: false);

      // Open Google Maps to customer address
      final launcher = ref.read(launcherServiceProvider);
      await launcher.navigateToAddress(widget.order.address);
    } catch (_) {
      if (!mounted) return;
      if (mounted) _snack(context, 'Could not update status. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _arriveToCustomer() async {
    await _updateStatus('atCustomer');
  }

  Future<void> _submitAndCompleteOrder() async {
    setState(() => _isLoading = true);
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();

      if (!cameraStatus.isGranted) {
        if (!mounted) return;
        setState(() => _isLoading = false);

        if (cameraStatus.isPermanentlyDenied) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Camera Permission Required'),
                content: const Text(
                  'Camera permission is permanently denied. Please enable it in app settings to capture delivery proof.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            );
          }
        } else {
          _snack(context, 'Camera permission is required to capture delivery proof');
        }
        return;
      }

      // Open camera
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo == null) {
        setState(() => _isLoading = false);
        if (mounted) _snack(context, 'Photo capture cancelled');
        return;
      }

      setState(() => _isLoading = false);

      // Navigate to submission screen for delivery photo
      if (!mounted) return;
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PickupSubmissionScreen(
              order: widget.order,
              photo: photo,
              title: 'Delivery Proof',
              descriptionLabel: 'Add delivery details (optional)',
              submitButtonText: 'Submit & Complete',
              onSubmit: (description) async {
                setState(() => _isLoading = true);

                try {
                   if (widget.order.driverId.isNotEmpty) {
                  // Upload photo to Firebase Storage
                  // TODO: Implement Firebase Storage upload for delivery photo
                  // For now, just save the description and complete delivery
                  await FirebaseFirestore.instance.collection('orders').doc(widget.order.id).update({
                    'status': 'delivered',
                    'updatedAt': FieldValue.serverTimestamp(),
                    'deliveryPhotoDescription': description,
                  });

                  // Record to driver's completed orders collection
                 
                    await FirebaseFirestore.instance
                        .collection('drivers')
                        .doc(widget.order.driverId)
                        .collection('completed_orders')
                        .doc(widget.order.id)
                        .set({
                      'order_id': widget.order.id,
                      'total_earnings': widget.order.total,
                      'delivery_type': 'verified_pod',
                      'completed_at': FieldValue.serverTimestamp(),
                    }, SetOptions(merge: true));
                     debugPrint("Errrrrrrrrrror");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => DeliverySuccessScreen(
                          order: widget.order,
                        ),
                      ),
                    );
                  }

                  if (!mounted) return;
                  if (mounted) _snack(context, 'Delivery completed successfully', error: false);

                  // Navigate to success screen
                  if (!mounted) return;
                
                   
                  
                } catch (e) {
                  if (!mounted) return;
                  if (mounted) _snack(context, 'Error: ${e.toString()}');
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      if (mounted) _snack(context, 'Error: ${e.toString()}');
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  Future<void> _submitSuccessful() async {
    try {
    
      AppRoutes.pushReplacementTo(
        context,
        DeliverySuccessScreen(order: widget.order),
      );
    } catch (e) {
      if (!mounted) return;
      if (mounted) _snack(context, 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
 
// latest version of the order (stream), falling back to the one passed in

String _getButtonText(model.Order order) {
  if (order.isAccepted) return 'Start Delivery';
  if (order.isInDelivery) return 'Arrive to Market';
  if (order.isAtMarket) return 'Start Pick Up';
  if (order.isPickingUp) return 'Continue Pick Up';
  if (order.isPickedUp) return 'Start Delivering';
  if (order.isDelivering) return 'Arrive to Customer';
  if (order.isAtCustomer) return 'Submit & Complete Order';
  return 'Done';
}

VoidCallback? _getButtonAction(model.Order order) {
 // if (order.isPending) return () => _updateStatus('accepted');
  if (order.isAccepted) return _startDelivery;
  if (order.isInDelivery) return _arriveToMarket;
  if (order.isAtMarket || order.isPickingUp) return _startPickUp;
  if (order.isPickedUp) return _startDelivering;
  if (order.isDelivering) return _arriveToCustomer;
  if (order.isAtCustomer) return _submitAndCompleteOrder;
  if(order.isDelivered) return _submitSuccessful;
  return null;
}
@override
Widget build(BuildContext context) {
   final myOrder = ref.watch(orderProvider(widget.order.id)).valueOrNull ?? widget.order;
  final launcher = ref.read(launcherServiceProvider);

  // ...your ref.listen stays the same

  return Scaffold(
    backgroundColor: AppColors.bg,
    bottomNavigationBar: AppButton(
      onAccept: _getButtonAction(myOrder) ?? () {},
      title: _getButtonText(myOrder),
      isLoading: _isLoading,
    ),
    body: SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: DeliveryAppBar(onSos: () {
              ref.read(deliveryActionsProvider.notifier).sendSos(myOrder.id);
              _snack(context, 'Emergency SOS sent to dispatch.');
            }),
          ),
          Body(
            order: myOrder,
            launcher: launcher,
            onLaunch: (f) => _launch(context, f),
            isAccepting: _isLoading,
          ),
        ],
      ),
    ),
  );
}
}
