import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/offer.dart';

String? _optionalLocalized(
  Map<String, dynamic> data,
  String primaryKey,
  String i18nKey,
  String locale,
) {
  final i18n = LocalizedText.parseMap(data[i18nKey]);
  final resolved = LocalizedText.resolve(
    primary: data[primaryKey],
    i18n: i18n,
    locale: locale,
    defaultLocale: locale,
  );
  return resolved.isEmpty ? null : resolved;
}

class OfferModel {
  OfferModel({
    required this.id,
    required this.businessId,
    required this.title,
    required this.slug,
    this.titleI18n = const {},
    this.description,
    this.descriptionI18n = const {},
    this.seoTitle,
    this.seoDescription,
    this.seoTitleI18n = const {},
    this.seoDescriptionI18n = const {},
    this.localizedSlugs = const {},
    required this.items,
    required this.productIds,
    required this.durationDays,
    required this.startsAt,
    required this.endsAt,
    this.discountPercent,
    this.active = true,
  });

  final String id;
  final String businessId;
  final String title;
  final String slug;
  final Map<String, String> titleI18n;
  final String? description;
  final Map<String, String> descriptionI18n;
  final String? seoTitle;
  final String? seoDescription;
  final Map<String, String> seoTitleI18n;
  final Map<String, String> seoDescriptionI18n;
  final Map<String, String> localizedSlugs;
  final List<OfferItem> items;
  final List<String> productIds;
  final int durationDays;
  final DateTime startsAt;
  final DateTime endsAt;
  final double? discountPercent;
  final bool active;

  factory OfferModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = 'sq',
  }) {
    final data = doc.data() ?? {};
    final rawItems = data['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return OfferItem(
            productId: m['productId'] as String? ?? '',
            discountPercent: (m['discountPercent'] as num?)?.toDouble(),
            salePriceEur: (m['salePriceEur'] as num?)?.toDouble(),
          );
        })
        .where((i) => i.productId.isNotEmpty)
        .toList();

    final titleI18n = LocalizedText.parseMap(data['titleI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
    final seoTitleI18n = LocalizedText.parseMap(data['seoTitleI18n']);
    final seoDescriptionI18n = LocalizedText.parseMap(data['seoDescriptionI18n']);
    final localizedSlugs = LocalizedText.parseMap(data['localizedSlugs']);

    return OfferModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      title: LocalizedText.resolve(
        primary: data['title'] as String?,
        i18n: titleI18n,
        locale: displayLocale,
      ),
      slug: (data['slug'] as String?)?.trim().isNotEmpty == true
          ? data['slug'] as String
          : doc.id,
      titleI18n: titleI18n,
      description: _optionalLocalized(data, 'description', 'descriptionI18n', displayLocale),
      descriptionI18n: descriptionI18n,
      seoTitle: _optionalLocalized(data, 'seoTitle', 'seoTitleI18n', displayLocale),
      seoDescription:
          _optionalLocalized(data, 'seoDescription', 'seoDescriptionI18n', displayLocale),
      seoTitleI18n: seoTitleI18n,
      seoDescriptionI18n: seoDescriptionI18n,
      localizedSlugs: localizedSlugs,
      items: items,
      productIds: List<String>.from(data['productIds'] as List? ?? []),
      durationDays: (data['durationDays'] as num?)?.toInt() ?? 7,
      startsAt: (data['startsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endsAt: (data['endsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      discountPercent: (data['discountPercent'] as num?)?.toDouble(),
      active: data['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'title': title,
      'slug': slug,
      if (titleI18n.isNotEmpty) 'titleI18n': titleI18n,
      if (description != null) 'description': description,
      if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
      if (seoTitle != null && seoTitle!.isNotEmpty) 'seoTitle': seoTitle,
      if (seoDescription != null && seoDescription!.isNotEmpty) 'seoDescription': seoDescription,
      if (seoTitleI18n.isNotEmpty) 'seoTitleI18n': seoTitleI18n,
      if (seoDescriptionI18n.isNotEmpty) 'seoDescriptionI18n': seoDescriptionI18n,
      if (localizedSlugs.isNotEmpty) 'localizedSlugs': localizedSlugs,
      'items': items
          .map(
            (i) => {
              'productId': i.productId,
              if (i.discountPercent != null) 'discountPercent': i.discountPercent,
              if (i.salePriceEur != null) 'salePriceEur': i.salePriceEur,
            },
          )
          .toList(),
      'productIds': productIds,
      'durationDays': durationDays,
      'startsAt': Timestamp.fromDate(startsAt),
      'endsAt': Timestamp.fromDate(endsAt),
      if (discountPercent != null) 'discountPercent': discountPercent,
      'active': active,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Offer toEntity() => Offer(
        id: id,
        businessId: businessId,
        title: title,
        slug: slug,
        titleI18n: titleI18n,
        description: description,
        descriptionI18n: descriptionI18n,
        seoTitle: seoTitle,
        seoDescription: seoDescription,
        seoTitleI18n: seoTitleI18n,
        seoDescriptionI18n: seoDescriptionI18n,
        localizedSlugs: localizedSlugs,
        items: items,
        productIds: productIds,
        durationDays: durationDays,
        startsAt: startsAt,
        endsAt: endsAt,
        discountPercent: discountPercent,
        active: active,
      );
}
