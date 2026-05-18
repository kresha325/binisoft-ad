import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/site_config.dart';
import '../../domain/entities/website_plan.dart';
import 'site_config_model.dart';

class BusinessModel {
  BusinessModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    this.slug,
    this.description,
    this.logoUrl,
    this.coverImageUrl,
    this.location,
    this.website,
    this.backgroundPresetId,
    this.backgroundImageUrl,
    this.backgroundOverlayOpacity,
    this.orderPhone,
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
  final String? website;
  final String? backgroundPresetId;
  final String? backgroundImageUrl;
  final double? backgroundOverlayOpacity;
  final String? orderPhone;
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

  factory BusinessModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final defaultLocale =
        AppLocales.normalize(data['defaultLocale'] as String?) ?? AppLocales.defaultLocale;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
    return BusinessModel(
      id: doc.id,
      name: LocalizedText.resolve(
        primary: data['name'],
        i18n: nameI18n,
        locale: defaultLocale,
        defaultLocale: defaultLocale,
      ),
      ownerId: data['ownerId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      slug: data['slug'] as String?,
      description: data['description'] as String?,
      logoUrl: data['logoUrl'] as String?,
      coverImageUrl: data['coverImageUrl'] as String?,
      location: data['location'] as String?,
      website: data['website'] as String?,
      backgroundPresetId: data['backgroundPresetId'] as String?,
      backgroundImageUrl: data['backgroundImageUrl'] as String?,
      backgroundOverlayOpacity: (data['backgroundOverlayOpacity'] as num?)?.toDouble(),
      orderPhone: data['orderPhone'] as String?,
      siteTemplateId: data['siteTemplateId'] as String?,
      siteDeployUrl: data['siteDeployUrl'] as String?,
      siteCustomDomain: data['siteCustomDomain'] as String?,
      siteDeployStatus: data['siteDeployStatus'] as String?,
      siteLastDeployAt: (data['siteLastDeployAt'] as Timestamp?)?.toDate(),
      siteConfig: data['siteConfig'] is Map
          ? SiteConfigModel.fromMap(Map<String, dynamic>.from(data['siteConfig'] as Map))
          : null,
      websitePlan: WebsitePlanX.fromFirestore(data['websitePlan'] as String?),
      professionalWebsiteRequestedAt:
          (data['professionalWebsiteRequestedAt'] as Timestamp?)?.toDate(),
      active: data['active'] as bool? ?? true,
      defaultLocale: defaultLocale,
      locales: AppLocales.normalizeList(
        (data['locales'] as List?)?.map((e) => e.toString()),
      ),
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ownerId': ownerId,
        'createdAt': Timestamp.fromDate(createdAt),
        'active': active,
        'defaultLocale': defaultLocale,
        'locales': locales,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
        if (slug != null) 'slug': slug,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
        if (location != null) 'location': location,
        if (website != null) 'website': website,
        if (backgroundPresetId != null) 'backgroundPresetId': backgroundPresetId,
        if (backgroundImageUrl != null) 'backgroundImageUrl': backgroundImageUrl,
        if (backgroundOverlayOpacity != null)
          'backgroundOverlayOpacity': backgroundOverlayOpacity,
        if (orderPhone != null) 'orderPhone': orderPhone,
      };

  Business toEntity() => Business(
        id: id,
        name: name,
        ownerId: ownerId,
        createdAt: createdAt,
        slug: slug,
        description: description,
        logoUrl: logoUrl,
        coverImageUrl: coverImageUrl,
        location: location,
        website: website,
        backgroundPresetId: backgroundPresetId,
        backgroundImageUrl: backgroundImageUrl,
        backgroundOverlayOpacity: backgroundOverlayOpacity,
        orderPhone: orderPhone,
        siteTemplateId: siteTemplateId,
        siteDeployUrl: siteDeployUrl,
        siteCustomDomain: siteCustomDomain,
        siteDeployStatus: siteDeployStatus,
        siteLastDeployAt: siteLastDeployAt,
        siteConfig: siteConfig,
        websitePlan: websitePlan,
        professionalWebsiteRequestedAt: professionalWebsiteRequestedAt,
        active: active,
        defaultLocale: defaultLocale,
        locales: locales,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
      );
}
