// import 'package:flutter/material.dart';
// import 'package:rice_delivery/core/theme/rice_brand.dart';

// /// rice_delivery brand and semantic colors.
// ///
// /// Brand fields forward to [RiceBrand] — change [RiceBrand.seed] only.
// /// Prefer [ColorScheme] from theme in new UI code.
// class AppColor {
//   static ColorScheme get _s => RiceBrand.light;

//   // ── rice_delivery brand (derived from seed) ───────────────────────────────────────
//   /// Navy — primary brand (headers, buttons, key text).
//   static Color get mainColor => RiceBrand.seed;

//   /// Accent — secondary / borders, icons, gradients.
//   static Color get subMainColor => _s.secondary;

//   /// Light tint for containers and highlights.
//   static Color get lightMainColor => _s.primaryContainer;

//   /// Center nav FAB inner circle.
//   static Color get navFabInnerBg =>
//       Color.lerp(Colors.white, _s.secondary, 0.08)!;

//   /// Dashboard quick-action icon well.
//   static Color get quickActionIconBg => navFabInnerBg;

//   /// Dashboard quick-action card border.
//   static Color get quickActionCardBorder =>
//       Color.lerp(_s.outlineVariant, _s.secondary, 0.25)!;

//   /// Dashboard “create course” banner fill.
//   static Color get createCourseBannerBg =>
//       Color.lerp(Colors.white, _s.secondary, 0.18)!;

//   /// Dashboard accent icons / dashed border.
//   static Color get dashboardAccent =>
//       Color.lerp(_s.secondary, RiceBrand.seed, 0.15)!;

//   /// Quick-action label.
//   static Color get quickActionLabel =>
//       Color.lerp(RiceBrand.seed, Colors.black, 0.15)!;

//   /// Deeper accent (OTP, tertiary actions).
//   static Color get accentColor => _s.tertiary;

//   /// App background (login, dashboard shell).
//   static Color get scaffoldColor => _s.surface;

//   // ── Surfaces & neutrals ─────────────────────────────────────────────────────
//   static const Color subColor = Color(0xFFFFFFFF);
//   static const Color subtextColor = Color(0xFF4B5563);
//   static Color get iconColor => RiceBrand.seed;
//   static Color get textColor => RiceBrand.seed;
//   static Color get lightGray => _s.outlineVariant;
//   static Color get borderColor => _s.outline;
//   static const Color mediumGray = Color(0xFFE2E8F0);
//   static const Color noColor = Colors.transparent;
//   static Color get textFormFieldColor => RiceBrand.seed;
//   static const Color black = Color(0xFF000000);
//   static const Color blackLight = Color(0xFF0F172A);
//   static const Color white = Color(0xFFFFFFFF);
//   static Color red = Colors.red[700]!;
//   static const Color lightRed = Color(0xFFFFC8C8);
//   static Color get green => _s.secondary;
//   static Color get lightGreen => _s.secondaryContainer;
//   static Color get blue => _s.tertiary;
//   static Color get lightBlue =>
//       Color.lerp(Colors.white, _s.secondary, 0.1)!;

//   // Text
//   static const Color textYellow = Color(0xFFFEC40E);
//   static const Color textGray = Color(0xFF6B7280);
//   static Color get subTitleColor =>
//       RiceBrand.seed.withValues(alpha: 0.7);
//   static Color get textBlack => RiceBrand.seed;

//   // Standard
//   static Color get standardLightGray => _s.surface;
//   static Color get scaffoldBackgroundColor => _s.surface;
//   static const Color standardWhite = Color(0xFFFFFFFF);
//   static Color get standardOffWhite => _s.surface;
//   static const Color standardYellow = Color(0xFFFEC40E);

//   // Semantic
//   static const Color otherRed = Color(0xFFEF4444);
//   static Color get otherGreen => _s.secondary;
//   static const Color otherDarkGray = Color(0xFF6B7280);
//   static const Color otherYellow = Color(0xFFFEC40E);

//   static Color get mainGradientColor => RiceBrand.seed;
//   static Color get secondGradientColor => _s.secondary;
//   static Color get otherGray => _s.surface;
// }
