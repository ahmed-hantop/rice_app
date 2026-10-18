import 'package:flutter/material.dart';

/// Shortcuts for brand colors from the active [Theme].
extension rice_deliveryThemeX on BuildContext {
  ColorScheme get rice_deliveryColors => Theme.of(this).colorScheme;

  Color get textPrimary => rice_deliveryColors.onSurface;
  Color get textMuted => rice_deliveryColors.onSurfaceVariant;
  Color get accent => rice_deliveryColors.secondary;
  Color get accentContainer => rice_deliveryColors.primaryContainer;
  Color get pageBg => rice_deliveryColors.surface;
  Color get border => rice_deliveryColors.outline;
  Color get onAccent => rice_deliveryColors.onSecondary;
}
