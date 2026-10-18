// presentation/widgets/photo_viewfinder.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import 'package:rice_delivery/core/services/location_service.dart';

class PhotoViewfinder extends StatelessWidget {
  const PhotoViewfinder({
    super.key,
    required this.photoPath,
    required this.location,
  });

  final String? photoPath;
  final Coordinates? location;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null;

    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.8)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: hasPhoto
                  ? Image.file(File(photoPath!), fit: BoxFit.cover)
                  : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 44, color: AppColors.hint),
                      SizedBox(height: 8),
                      Text('Tap to take the delivery photo',
                          style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
            ),
            if (location != null)
              Positioned(
                top: 10,
                left: 12,
                child: _Badge(
                  color: Colors.black.withOpacity(0.75),
                  child: Text('GPS: ${location!.label}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5)),
                ),
              ),
            if (hasPhoto) ...[
              Positioned(
                bottom: 12,
                left: 12,
                child: _Badge(
                  color: AppColors.green,
                  child: const Text('PHOTO CAPTURED ✓',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onGreen,
                          letterSpacing: 0.5)),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: _Badge(
                  color: AppColors.field.withOpacity(0.85),
                  border: AppColors.border,
                  child: const Row(children: [
                    Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Retake',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.child, this.border});
  final Color color;
  final Color? border;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: border == null ? null : Border.all(color: border!),
        ),
        child: child,
      );
}