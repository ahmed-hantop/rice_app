import 'package:flutter/material.dart';

/// Single brand knob for the student app.
///
/// Change [seed] only — [lightScheme] / [darkScheme] and all brand aliases
/// ([AppColor], [RiceColorTokens], [HomeV4Colors]) derive from it.
abstract final class RiceBrand {
  /// Navy ink — the only manual brand color.
  static const Color seed = Color(0xFF003555);
  

  static ColorScheme? _light;
  static ColorScheme? _dark;

  /// Cached light scheme (no [BuildContext] needed for tokens).
  static ColorScheme get light => _light ??= lightScheme();

  /// Cached dark scheme.
  static ColorScheme get dark => _dark ??= darkScheme();

  /// Accent derived from [seed] (teal family for navy seed).
  static Color accentOf(ColorScheme scheme) => scheme.secondary;

  static ColorScheme lightScheme({Color? seedOverride}) {
    final seedColor = seedOverride ?? seed;
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    // Product rules: ink = seed; CTA / borders = secondary from seed harmony.
    return base.copyWith(
      onSurface: seedColor,
      onPrimaryContainer: seedColor,
      onSecondaryContainer: seedColor,
      onTertiaryContainer: seedColor,
      // Keep CTA/accent as the seed-harmonized secondary (teal-ish for navy).
      primary: base.secondary,
      onPrimary: Colors.white,
      secondary: base.secondary,
      onSecondary: Colors.white,
      tertiary: Color.lerp(base.secondary, seedColor, 0.35)!,
      onTertiary: Colors.white,
      surface: Color.lerp(Colors.white, seedColor, 0.04)!,
      surfaceContainerHighest: Colors.white,
      onSurfaceVariant: seedColor.withValues(alpha: 0.7),
      outline: Color.lerp(const Color(0xFFD1D5DC), seedColor, 0.08)!,
      outlineVariant: Color.lerp(const Color(0xFFE5E7EB), seedColor, 0.05)!,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: const Color(0xFFB91C1C),
      shadow: Colors.black.withValues(alpha: 0.12),
      scrim: Colors.black.withValues(alpha: 0.4),
      surfaceTint: const Color(0xFFFFB900),
      inverseSurface: base.secondary,
      onInverseSurface: Colors.white,
      inversePrimary: seedColor,
    );
  }

  static ColorScheme darkScheme({Color? seedOverride}) {
    final seedColor = seedOverride ?? seed;
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      onSurface: Color.lerp(Colors.white, seedColor, 0.04)!,
      surface: const Color(0xFF0F172A),
      surfaceContainerHighest: const Color(0xFF1E293B),
      primary: base.secondary,
      onPrimary: seedColor,
      secondary: base.tertiary,
      onSecondary: Colors.white,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      shadow: Colors.black.withValues(alpha: 0.5),
      scrim: Colors.black.withValues(alpha: 0.6),
    );
  }

  /// Clear caches after changing [seed] in tests / hot-reload experiments.
  static void resetCaches() {
    _light = null;
    _dark = null;
  }
}
