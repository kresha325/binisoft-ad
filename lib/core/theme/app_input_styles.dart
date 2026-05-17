import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_scheme.dart';
import 'app_design.dart';
import 'app_theme.dart';

/// Theme-aware text field / dropdown styling (light + dark).
abstract final class AppInputStyles {
  static TextStyle fieldText(BuildContext context) => GoogleFonts.inter(
        fontSize: 15,
        color: context.appColors.textPrimary,
      );

  static TextStyle hintText(BuildContext context) => GoogleFonts.inter(
        fontSize: 15,
        color: context.appColors.textMuted,
      );

  static TextStyle labelText(BuildContext context) => AppTextStyles.fieldLabel(context);

  static InputDecoration decoration(
    BuildContext context, {
    String? hintText,
    String? labelText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool borderless = false,
  }) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(AppDesign.radiusMd);

    final border = borderless
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: colors.inputBorder),
          );

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.surfaceElevated,
      hintStyle: hintTextStyle(context),
      labelStyle: labelTextStyle(context),
      helperStyle: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: borderless
          ? InputBorder.none
          : OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: colors.accent, width: 1.5),
            ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.danger),
      ),
    );
  }

  static InputDecoration dropdownDecoration(
    BuildContext context, {
    String? labelText,
    String? hintText,
  }) =>
      decoration(context, labelText: labelText, hintText: hintText);

  static TextStyle hintTextStyle(BuildContext context) => hintText(context);

  static TextStyle labelTextStyle(BuildContext context) => labelText(context);
}
