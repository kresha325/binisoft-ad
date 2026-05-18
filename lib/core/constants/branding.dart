import 'package:flutter/material.dart';

/// Binisoft product branding (admin dashboard).
abstract final class AppBranding {
  static const appTitle = 'Binisoft Admin Dashboard';
  static const tagline = 'Software and Customer Solutions';
  static const splashTagline = 'Real time update your business';
  static const logoAsset = 'assets/branding/binisoft_logo.png';
  static const logoAssetDark = 'assets/branding/binisoft_logo_dark.png';

  /// Wordmark aspect (width ÷ height), ~1009×177px source art.
  static const double logoAspectRatio = 1009 / 177;

  /// Header wordmark width multiplier (natural aspect × this).
  static const double headerLogoWidthScale = 1.55;

  static const double headerLogoHeightMobile = 18;
  static const double headerLogoHeightDesktop = 26;

  /// Pulls the wordmark left to align with shell edge (asset has side padding).
  static const double headerLogoVisualOffsetX = -28;

  /// Horizontal nudge for wordmark art with side padding (0 = geometric center).
  static const double splashLogoVisualOffsetX = 0;

  static String logoAssetFor(Brightness brightness) =>
      brightness == Brightness.dark ? logoAssetDark : logoAsset;

  static const splashDuration = Duration(seconds: 5);
}
