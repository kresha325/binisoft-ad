import '../../business/domain/entities/site_config.dart';

/// Unsaved storefront snapshot for in-app preview (profile + optional site layout).
class ShopPreviewData {
  const ShopPreviewData({
    required this.name,
    this.slug,
    this.heroTagline,
    this.aboutBio,
    this.logoUrl,
    this.coverUrl,
    this.postalCode,
    this.city,
    this.state,
    this.orderPhone,
    this.contactEmail,
    this.openingHours,
    this.website,
    this.businessTypeLabel,
    this.siteConfig,
  });

  final String name;
  final String? slug;
  final String? heroTagline;
  final String? aboutBio;
  final String? logoUrl;
  final String? coverUrl;
  final String? postalCode;
  final String? city;
  final String? state;
  final String? orderPhone;
  final String? contactEmail;
  final String? openingHours;
  final String? website;
  final String? businessTypeLabel;
  final SiteConfig? siteConfig;

  String get locationLine {
    final c = city?.trim() ?? '';
    final s = state?.trim() ?? '';
    if (c.isNotEmpty && s.isNotEmpty) return '$c, $s';
    if (c.isNotEmpty) return c;
    return s;
  }
}
