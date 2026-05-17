import 'package:flutter/material.dart';

import '../constants/dashboard_backgrounds.dart';
import '../theme/app_color_scheme.dart';
import 'glass_surface.dart';
import 'storage_network_image.dart';

/// Full-screen background behind admin content (preset, custom URL, or gradient).
/// Wallpaper images are shown only in dark mode; light mode uses a glass gradient.
class DashboardBackgroundLayer extends StatelessWidget {
  const DashboardBackgroundLayer({
    super.key,
    required this.presetId,
    this.customImageUrl,
    this.overlayOpacity = DashboardBackgrounds.defaultOverlayOpacity,
  });

  final String? presetId;
  final String? customImageUrl;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDarkMode;

    if (!isDark) {
      return const LightGlassBackdrop();
    }

    final hasWallpaper = DashboardBackgrounds.hasActiveBackground(
      presetId: presetId,
      customImageUrl: customImageUrl,
    );

    if (!hasWallpaper) {
      return ColoredBox(color: colors.scaffoldBg);
    }

    final preset = DashboardBackgrounds.byId(presetId);
    final custom = customImageUrl?.trim();
    final effectiveOpacity = DashboardBackgrounds.effectiveOverlayOpacity(
      overlayOpacity,
      isDarkMode: true,
      hasWallpaper: true,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (custom != null && custom.isNotEmpty)
          StorageNetworkImage(url: custom, fit: BoxFit.cover)
        else if (preset != null && preset.hasAsset)
          Image.asset(
            preset.assetPath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _GradientFill(gradient: preset.previewGradient),
          )
        else if (preset != null)
          _GradientFill(gradient: preset.previewGradient)
        else
          ColoredBox(color: colors.scaffoldBg),
        ColoredBox(
          color: colors.backgroundOverlayBase.withValues(alpha: effectiveOpacity),
        ),
      ],
    );
  }
}

class _GradientFill extends StatelessWidget {
  const _GradientFill({required this.gradient});

  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
    );
  }
}
