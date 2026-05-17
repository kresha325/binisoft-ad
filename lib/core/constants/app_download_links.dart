import '../utils/client_platform.dart';

/// Store / download URLs — update when apps are published.
abstract final class AppDownloadLinks {
  /// Apple App Store app id (numeric). Leave empty until published.
  static const String iosAppStoreId = '';

  static const String androidPackageId = 'com.jonsport.business_dashboard';

  /// macOS App Store id (optional; can match iOS universal app).
  static const String macAppStoreId = '';

  /// Microsoft Store product id (optional).
  static const String windowsStoreProductId = '';

  /// Direct download for Linux / Windows sideload (optional).
  static const String linuxDownloadUrl = '';
  static const String windowsDirectDownloadUrl = '';

  /// Web admin (always available).
  static const String webAppPath = '/login';

  static String get iosAppStoreUrl => iosAppStoreId.isEmpty
      ? ''
      : 'https://apps.apple.com/app/id$iosAppStoreId';

  static String get androidPlayStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  static String get macAppStoreUrl =>
      macAppStoreId.isEmpty ? '' : 'https://apps.apple.com/app/id$macAppStoreId';

  static String get windowsStoreUrl => windowsStoreProductId.isEmpty
      ? ''
      : 'https://apps.microsoft.com/store/detail/$windowsStoreProductId';

  static String? urlFor(ClientPlatform platform) => switch (platform) {
        ClientPlatform.ios => iosAppStoreUrl.isEmpty ? null : iosAppStoreUrl,
        ClientPlatform.android => androidPlayStoreUrl,
        ClientPlatform.macos =>
          macAppStoreUrl.isEmpty ? (iosAppStoreUrl.isEmpty ? null : iosAppStoreUrl) : macAppStoreUrl,
        ClientPlatform.windows => windowsStoreUrl.isEmpty
            ? (windowsDirectDownloadUrl.isEmpty ? null : windowsDirectDownloadUrl)
            : windowsStoreUrl,
        ClientPlatform.linux =>
          linuxDownloadUrl.isEmpty ? null : linuxDownloadUrl,
        ClientPlatform.web => null,
        ClientPlatform.unknown => null,
      };

  static String labelFor(ClientPlatform platform) => switch (platform) {
        ClientPlatform.ios => 'App Store',
        ClientPlatform.android => 'Google Play',
        ClientPlatform.macos => 'Mac App Store',
        ClientPlatform.windows => 'Microsoft Store',
        ClientPlatform.linux => 'Download for Linux',
        ClientPlatform.web => 'Web dashboard',
        ClientPlatform.unknown => 'Download',
      };

  static String subtitleFor(ClientPlatform platform) => switch (platform) {
        ClientPlatform.ios => 'iPhone & iPad',
        ClientPlatform.android => 'Phones & tablets',
        ClientPlatform.macos => 'Mac desktop',
        ClientPlatform.windows => 'Windows PC',
        ClientPlatform.linux => 'Linux desktop',
        ClientPlatform.web => 'Use in your browser',
        ClientPlatform.unknown => 'Get the app',
      };
}
