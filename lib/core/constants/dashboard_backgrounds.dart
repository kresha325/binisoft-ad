import 'package:flutter/material.dart';

/// Dashboard background presets (inspired by abstract glass / fluid Dribbble shots).
class DashboardBackgroundPreset {
  const DashboardBackgroundPreset({
    required this.id,
    required this.title,
    required this.previewGradient,
    this.assetPath,
    this.referenceUrl,
  });

  final String id;
  final String title;
  final Gradient previewGradient;
  final String? assetPath;
  final String? referenceUrl;

  bool get hasAsset => assetPath != null && assetPath!.isNotEmpty;
}

class DashboardBackgrounds {
  DashboardBackgrounds._();

  static const noneId = 'none';

  /// White wash over the wallpaper (0 = full image, ~0.9 = almost solid grey).
  static const double defaultOverlayOpacity = 0.42;
  static const double minOverlayOpacity = 0.0;
  static const double maxOverlayOpacity = 0.92;

  static double resolveOverlayOpacity(double? stored) {
    if (stored == null || stored.isNaN) return defaultOverlayOpacity;
    return stored.clamp(minOverlayOpacity, maxOverlayOpacity);
  }

  /// In dark mode, wallpaper needs a stronger tint so content stays readable.
  static double effectiveOverlayOpacity(
    double? stored, {
    required bool isDarkMode,
    required bool hasWallpaper,
  }) {
    final resolved = resolveOverlayOpacity(stored);
    if (!hasWallpaper || !isDarkMode) return resolved;
    if (resolved <= defaultOverlayOpacity + 0.05) return 0.62;
    return resolved;
  }

  static bool hasActiveBackground({
    String? presetId,
    String? customImageUrl,
  }) {
    if (customImageUrl != null && customImageUrl.trim().isNotEmpty) return true;
    if (presetId == null || presetId.isEmpty || presetId == noneId) return false;
    return true;
  }

  static const List<DashboardBackgroundPreset> presets = [
    DashboardBackgroundPreset(
      id: 'twisted_emitter_bright',
      title: 'Twisted glass · bright',
      referenceUrl:
          'https://dribbble.com/shots/20103292-Twisted-emitter-glass-bright-abstract-background',
      assetPath: 'assets/backgrounds/twisted_emitter_bright.jpg',
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF7DD3FC),
          Color(0xFFC4B5FD),
          Color(0xFFF9A8D4),
          Color(0xFFFDE68A),
        ],
      ),
    ),
    DashboardBackgroundPreset(
      id: 'frosty_twisted_ii',
      title: 'Frosty twisted glass II',
      referenceUrl:
          'https://dribbble.com/shots/19936661-Frosty-twisted-glass-abstract-background-II',
      assetPath: 'assets/backgrounds/frosty_twisted_glass_ii.jpg',
      previewGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE0F2FE),
          Color(0xFFBAE6FD),
          Color(0xFF94A3B8),
          Color(0xFFCBD5E1),
        ],
      ),
    ),
    DashboardBackgroundPreset(
      id: 'twisted_emitter',
      title: 'Twisted emitter glass',
      referenceUrl:
          'https://dribbble.com/shots/19940902-Twisted-emitter-glass-abstract-background',
      assetPath: 'assets/backgrounds/twisted_emitter.jpg',
      previewGradient: LinearGradient(
        begin: Alignment(-0.8, -1),
        end: Alignment(0.9, 1),
        colors: [
          Color(0xFF312E81),
          Color(0xFF6366F1),
          Color(0xFF22D3EE),
          Color(0xFF0F172A),
        ],
      ),
    ),
    DashboardBackgroundPreset(
      id: 'twisted_emitter_ii',
      title: 'Twisted emitter glass II',
      referenceUrl:
          'https://dribbble.com/shots/19952443-Twisted-emitter-glass-abstract-background-II',
      assetPath: 'assets/backgrounds/twisted_emitter_ii.jpg',
      previewGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF4C1D95),
          Color(0xFF7C3AED),
          Color(0xFF38BDF8),
          Color(0xFF1E1B4B),
        ],
      ),
    ),
    DashboardBackgroundPreset(
      id: 'fluid_wave',
      title: 'Fluid wave',
      referenceUrl: 'https://dribbble.com/shots/19622802-Fluid-wave-abstract-background',
      assetPath: 'assets/backgrounds/fluid_wave.jpg',
      previewGradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF0EA5E9),
          Color(0xFF2DD4BF),
          Color(0xFF0284C7),
          Color(0xFF164E63),
        ],
      ),
    ),
    DashboardBackgroundPreset(
      id: 'metallic_fabric_ii',
      title: 'Metallic fabric II',
      referenceUrl:
          'https://dribbble.com/shots/20052914-Metallic-fabric-abstract-background-II',
      assetPath: 'assets/backgrounds/metallic_fabric_ii.jpg',
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD4D4D8),
          Color(0xFFF4F4F5),
          Color(0xFFA1A1AA),
          Color(0xFF71717A),
        ],
      ),
    ),
  ];

  static DashboardBackgroundPreset? byId(String? id) {
    if (id == null || id.isEmpty || id == noneId) return null;
    for (final p in presets) {
      if (p.id == id) return p;
    }
    return null;
  }
}
