import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import '../theme/app_theme.dart';

/// Frosted glass panels for light mode; solid surfaces in dark mode.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.showShadow = true,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final bool showShadow;

  static bool useGlass(BuildContext context) => !context.isDarkMode;

  static BorderRadius radiusLg(BuildContext context) =>
      BorderRadius.circular(AppDesign.radiusLg);

  static BoxDecoration decoration(
    BuildContext context, {
    BorderRadius? borderRadius,
  }) {
    final br = borderRadius ?? radiusLg(context);
    if (!useGlass(context)) {
      final colors = context.appColors;
      return BoxDecoration(
        color: colors.surface,
        borderRadius: br,
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.card(context),
      );
    }

    return BoxDecoration(
      borderRadius: br,
      border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.78),
          Colors.white.withValues(alpha: 0.52),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1A2B56).withValues(alpha: 0.07),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? radiusLg(context);
    final decoration = GlassSurface.decoration(context, borderRadius: br);

    if (!useGlass(context)) {
      return Container(
        decoration: decoration,
        padding: padding,
        clipBehavior: clipBehavior,
        child: child,
      );
    }

    return DecoratedBox(
      decoration: showShadow
          ? BoxDecoration(
              boxShadow: decoration.boxShadow,
              borderRadius: br,
            )
          : const BoxDecoration(),
      child: ClipRRect(
        borderRadius: br,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: br,
              border: decoration.border,
              gradient: decoration.gradient,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Soft gradient scaffold used in light mode (no wallpaper).
class LightGlassBackdrop extends StatelessWidget {
  const LightGlassBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDCE8F8),
            Color(0xFFEEF1F8),
            Color(0xFFE4E9F4),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
