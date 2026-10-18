import 'package:flutter/material.dart';

class AppTypography {
  // Font families (using system fonts until custom fonts are downloaded)
  static const String? primaryFont = null; // Uses system default
  static const String? secondaryFont = null; // Uses system default

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Enhanced Display styles with modern typography
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Enhanced Headline styles with better hierarchy
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.1,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    height: 1.45,
    letterSpacing: 0.1,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    height: 1.5,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    height: 1.35,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // Special styles using Poppins for accent text
  static const TextStyle accent = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    height: 1.4,
  );

  static const TextStyle accentLarge = TextStyle(
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.3,
  );

  static const TextStyle accentSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
  );

  // Enhanced Button styles with modern typography
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // Caption and overline
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    height: 1.35,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    height: 1.6,
    letterSpacing: 1.5,
  );
}
