import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_scheme.dart';
import 'app_design.dart';

class AppColors {
  static const navy = Color(0xFF1A2B56);
  static const accentTeal = Color(0xFF2EC4C6);
  static const primary = navy;
  static const primaryHover = Color(0xFF152347);
  static const scaffoldBg = Color(0xFFF0F2F6);
  static const cardBorder = Color(0xFFE2E8F0);
  static const inputBorder = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFF64748B);
  static const textDark = Color(0xFF0F172A);
  static const tableHeaderBg = Color(0xFFF8FAFC);
  static const greenBadge = Color(0xFF16A34A);
}

class AppShadows {
  static List<BoxShadow> card(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark ? 0.32 : 0.06,
          ),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static const authCard = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 48,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const menu = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}

class AppTextStyles {
  static TextStyle pageTitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: context.appColors.textPrimary,
        height: 1.15,
        letterSpacing: -0.4,
      );

  static TextStyle pageSubtitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: context.appColors.textMuted,
        height: 1.45,
      );

  static TextStyle authTitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: context.appColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle fieldLabel(BuildContext context) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: context.appColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle statValue(BuildContext context) => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: context.appColors.textPrimary,
        height: 1,
        letterSpacing: -0.5,
      );

  static TextStyle statLabel(BuildContext context) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: context.appColors.textMuted,
        letterSpacing: 0.2,
      );

  static TextStyle tableHeader(BuildContext context) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: context.appColors.textMuted,
        letterSpacing: 0.6,
      );
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColorScheme.light);

  static ThemeData dark() => _build(Brightness.dark, AppColorScheme.dark);

  static ThemeData _build(Brightness brightness, AppColorScheme scheme) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: 'Inter',
        );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: scheme.accent,
      onPrimary: isDark ? AppColors.navy : Colors.white,
      secondary: scheme.accent,
      onSecondary: isDark ? AppColors.navy : Colors.white,
      surface: scheme.surface,
      onSurface: scheme.textPrimary,
      onSurfaceVariant: scheme.textMuted,
      error: scheme.danger,
      onError: Colors.white,
      outline: scheme.inputBorder,
      outlineVariant: scheme.cardBorder,
      surfaceContainerHighest: scheme.surfaceElevated,
    );

    final borderRadius = BorderRadius.circular(AppDesign.radiusMd);
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDesign.radiusLg),
      side: BorderSide(color: scheme.cardBorder),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      textTheme: base.apply(
        bodyColor: scheme.textPrimary,
        displayColor: scheme.textPrimary,
      ),
      scaffoldBackgroundColor: scheme.scaffoldBg,
      colorScheme: colorScheme,
      extensions: [scheme],
      dividerColor: scheme.cardBorder,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: scheme.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.accent,
          foregroundColor: isDark ? AppColors.navy : Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.accent,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.textPrimary,
          side: BorderSide(color: scheme.cardBorder),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: cardShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          side: BorderSide(color: scheme.cardBorder),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: scheme.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 15,
          color: scheme.textMuted,
          height: 1.45,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? scheme.surfaceElevated : scheme.textPrimary,
        contentTextStyle: GoogleFonts.inter(
          color: isDark ? scheme.textPrimary : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDesign.radiusXl)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surfaceElevated : scheme.surfaceElevated.withValues(alpha: 0.85),
        hintStyle: GoogleFonts.inter(color: scheme.textMuted, fontSize: 15),
        labelStyle: GoogleFonts.inter(
          color: scheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: GoogleFonts.inter(color: scheme.textMuted, fontSize: 12),
        errorStyle: GoogleFonts.inter(color: scheme.danger, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.danger),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.accent,
        selectionColor: scheme.accent.withValues(alpha: 0.35),
        selectionHandleColor: scheme.accent,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.inter(fontSize: 15, color: scheme.textPrimary),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          side: BorderSide(color: scheme.cardBorder),
        ),
        textStyle: GoogleFonts.inter(fontSize: 14, color: scheme.textPrimary),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.accent,
        unselectedLabelColor: scheme.textMuted,
        indicatorColor: scheme.accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
        dividerColor: scheme.cardBorder,
      ),
      dividerTheme: DividerThemeData(color: scheme.cardBorder, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.accent,
        linearTrackColor: scheme.cardBorder,
      ),
    );
  }
}
