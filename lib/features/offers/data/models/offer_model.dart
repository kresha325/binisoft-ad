import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/offer.dart';

class OfferModel {
  OfferModel({
    required this.id,
    required this.businessId,
    required this.title,
    this.titleI18n = const {},
    this.description,
    this.descriptionI18n = const {},
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
  final Map<String, String> titleI18n;
  final String? description;
  final Map<String, String> descriptionI18n;
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

    return OfferModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      title: LocalizedText.resolve(
        primary: data['title'] as String?,
        i18n: Map<String, String>.from(data['titleI18n'] as Map? ?? {}),
        locale: displayLocale,
      ),
      titleI18n: Map<String, String>.from(data['titleI18n'] as Map? ?? {}),
      description: LocalizedText.resolve(
        primary: data['description'] as String?,
        i18n: Map<String, String>.from(data['descriptionI18n'] as Map? ?? {}),
        locale: displayLocale,
      ),
      descriptionI18n:
          Map<String, String>.from(data['descriptionI18n'] as Map? ?? {}),
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
      if (titleI18n.isNotEmpty) 'titleI18n': titleI18n,
      if (description != null) 'description': description,
      if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
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
        titleI18n: titleI18n,
        description: description,
        descriptionI18n: descriptionI18n,
        items: items,
        productIds: productIds,
        durationDays: durationDays,
        startsAt: startsAt,
        endsAt: endsAt,
        discountPercent: discountPercent,
        active: active,
      );
}
