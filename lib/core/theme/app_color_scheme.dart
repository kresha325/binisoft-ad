import 'package:flutter/material.dart';

/// Semantic colors for light / dark (use via [Theme.of(context).extension]).
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.scaffoldBg,
    required this.surface,
    required this.surfaceElevated,
    required this.cardBorder,
    required this.inputBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.tableHeaderBg,
    required this.backgroundOverlayBase,
    required this.chipBg,
    required this.accent,
    required this.accentSoft,
    required this.danger,
    required this.success,
  });

  final Color scaffoldBg;
  final Color surface;
  final Color surfaceElevated;
  final Color cardBorder;
  final Color inputBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color tableHeaderBg;
  final Color backgroundOverlayBase;
  final Color chipBg;
  final Color accent;
  final Color accentSoft;
  final Color danger;
  final Color success;

  /// Light “glass” theme — frosted panels over a soft gradient scaffold.
  static const light = AppColorScheme(
    scaffoldBg: Color(0xFFEEF1F8),
    surface: Color(0xCCFFFFFF),
    surfaceElevated: Color(0xE6FFFFFF),
    cardBorder: Color(0x99FFFFFF),
    inputBorder: Color(0xFFB8C4D4),
    textPrimary: Color(0xFF0F172A),
    textMuted: Color(0xFF64748B),
    tableHeaderBg: Color(0x66FFFFFF),
    backgroundOverlayBase: Color(0xFFEEF1F8),
    chipBg: Color(0x1A1A2B56),
    accent: Color(0xFF1A2B56),
    accentSoft: Color(0x1A2EC4C6),
    danger: Color(0xFFDC2626),
    success: Color(0xFF16A34A),
  );

  static const dark = AppColorScheme(
    scaffoldBg: Color(0xFF0A0F1A),
    surface: Color(0xFF131B2B),
    surfaceElevated: Color(0xFF1A2436),
    cardBorder: Color(0xFF2A3548),
    inputBorder: Color(0xFF3D4A5C),
    textPrimary: Color(0xFFF1F5F9),
    textMuted: Color(0xFF94A3B8),
    tableHeaderBg: Color(0xFF161F2E),
    backgroundOverlayBase: Color(0xFF0A0F1A),
    chipBg: Color(0x332EC4C6),
    accent: Color(0xFF2EC4C6),
    accentSoft: Color(0x332EC4C6),
    danger: Color(0xFFF87171),
    success: Color(0xFF4ADE80),
  );

  @override
  AppColorScheme copyWith({
    Color? scaffoldBg,
    Color? surface,
    Color? surfaceElevated,
    Color? cardBorder,
    Color? inputBorder,
    Color? textPrimary,
    Color? textMuted,
    Color? tableHeaderBg,
    Color? backgroundOverlayBase,
    Color? chipBg,
    Color? accent,
    Color? accentSoft,
    Color? danger,
    Color? success,
  }) {
    return AppColorScheme(
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      cardBorder: cardBorder ?? this.cardBorder,
      inputBorder: inputBorder ?? this.inputBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      tableHeaderBg: tableHeaderBg ?? this.tableHeaderBg,
      backgroundOverlayBase: backgroundOverlayBase ?? this.backgroundOverlayBase,
      chipBg: chipBg ?? this.chipBg,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      danger: danger ?? this.danger,
      success: success ?? this.success,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      tableHeaderBg: Color.lerp(tableHeaderBg, other.tableHeaderBg, t)!,
      backgroundOverlayBase:
          Color.lerp(backgroundOverlayBase, other.backgroundOverlayBase, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension AppColorSchemeContext on BuildContext {
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
