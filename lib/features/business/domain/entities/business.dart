import 'package:equatable/equatable.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/utils/google_maps_url.dart' as maps_util;
import '../business_address.dart';
import 'business_type.dart';
import 'shop_checkout_config.dart';
import 'site_config.dart';
import 'website_plan.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    this.slug,
    this.description,
    this.logoUrl,
    this.coverImageUrl,
    this.location,
    this.city,
    this.state,
    this.postalCode,
    this.website,
    this.backgroundPresetId,
    this.backgroundImageUrl,
    this.backgroundOverlayOpacity,
    this.orderPhone,
    this.contactEmail,
    this.siteTemplateId,
    this.siteDeployUrl,
    this.siteCustomDomain,
    this.siteDeployStatus,
    this.siteLastDeployAt,
    this.siteConfig,
    this.websitePlan,
    this.professionalWebsiteRequestedAt,
    this.active = true,
    this.defaultLocale = AppLocales.defaultLocale,
    this.locales = AppLocales.all,
    this.nameI18n = const {},
    this.descriptionI18n = const {},
    this.businessType,
    this.googleMapsUrl,
    this.aboutBio,
    this.openingHours,
    this.legalName,
    this.nipt,
    this.fiscalAddress,
    this.shopCheckout = ShopCheckoutConfig.defaults,
  });

  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;
  final bool active;
  final String? slug;
  final String? description;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? location;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? website;
  final String? backgroundPresetId;
  final String? backgroundImageUrl;
  final double? backgroundOverlayOpacity;
  final String? orderPhone;
  final String? contactEmail;
  final String? siteTemplateId;
  final String? siteDeployUrl;
  final String? siteCustomDomain;
  final String? siteDeployStatus;
  final DateTime? siteLastDeployAt;
  final SiteConfig? siteConfig;
  final WebsitePlan? websitePlan;
  final DateTime? professionalWebsiteRequestedAt;
  final String defaultLocale;
  final List<String> locales;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final BusinessType? businessType;
  /// Share link from Google Maps (used to build embed on public site).
  final String? googleMapsUrl;
  /// Long-form “Rreth nesh” text (public shop).
  final String? aboutBio;
  /// Opening hours shown on contact / footer (e.g. Hënë–Prem 09:00–22:00).
  final String? openingHours;
  /// Legal name on ATK invoices (may differ from public shop name).
  final String? legalName;
  final String? nipt;
  final String? fiscalAddress;

  final ShopCheckoutConfig shopCheckout;

  String? get googleMapsEmbedUrl => maps_util.googleMapsEmbedUrl(googleMapsUrl);

  String get displayLocation => BusinessAddress.displayLocation(
        city: city,
        state: state,
        legacyLocation: location,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        ownerId,
        createdAt,
        slug,
        description,
        logoUrl,
        coverImageUrl,
        location,
        city,
        state,
        postalCode,
        website,
        backgroundPresetId,
        backgroundImageUrl,
        backgroundOverlayOpacity,
        orderPhone,
        contactEmail,
        siteTemplateId,
        siteDeployUrl,
        siteCustomDomain,
        siteDeployStatus,
        siteLastDeployAt,
        siteConfig,
        websitePlan,
        professionalWebsiteRequestedAt,
        active,
        defaultLocale,
        locales,
        nameI18n,
        descriptionI18n,
        businessType,
        googleMapsUrl,
        aboutBio,
        openingHours,
        legalName,
        nipt,
        fiscalAddress,
        shopCheckout,
      ];
}
