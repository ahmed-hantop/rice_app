// features/delivery/presentation/screen/pickup_submission_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/widgets/app_button.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class PickupSubmissionScreen extends StatefulWidget {
  const PickupSubmissionScreen({
    super.key,
    required this.order,
    required this.photo,
    required this.onSubmit,
    this.title = 'Confirm Pickup',
    this.descriptionLabel = 'Add details (optional)',
    this.submitButtonText = 'Confirm Pickup',
  });

final model.Order order;
  final XFile photo;
  final Future<void> Function(String description) onSubmit;
  final String title;
  final String descriptionLabel;
  final String submitButtonText;

  @override
  State<PickupSubmissionScreen> createState() => _PickupSubmissionScreenState();
}

class _PickupSubmissionScreenState extends State<PickupSubmissionScreen> {
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_descriptionController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo preview
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.photo.path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, color: AppColors.muted, size: 48),
                                  SizedBox(height: 12),
                                  Text(
                                    'Could not load image',
                                    style: TextStyle(color: AppColors.muted),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description label
                    Text(
                      widget.descriptionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description text field
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter any additional details...',
                        hintStyle: TextStyle(color: AppColors.muted.withValues(alpha: 0.7)),
                        filled: true,
                        fillColor: AppColors.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.green, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppButton(
                onAccept: _isSubmitting ? () {} : _handleSubmit,
                title: widget.submitButtonText,
                isLoading: _isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
