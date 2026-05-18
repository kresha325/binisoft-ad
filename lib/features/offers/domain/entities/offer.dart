import 'package:equatable/equatable.dart';

/// How a product price is reduced within an offer.
enum OfferDiscountMode { percent, salePrice }

/// Display lifecycle (like product status, but time-bound).
enum OfferLifecycleStatus {
  live,
  scheduled,
  expired,
  inactive,
}

class OfferItem extends Equatable {
  const OfferItem({
    required this.productId,
    this.discountPercent,
    this.salePriceEur,
  });

  final String productId;
  final double? discountPercent;
  final double? salePriceEur;

  OfferDiscountMode get mode =>
      salePriceEur != null ? OfferDiscountMode.salePrice : OfferDiscountMode.percent;

  @override
  List<Object?> get props => [productId, discountPercent, salePriceEur];
}

class Offer extends Equatable {
  const Offer({
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

  bool get isCurrentlyActive => lifecycleStatus == OfferLifecycleStatus.live;

  OfferLifecycleStatus get lifecycleStatus {
    if (!active) return OfferLifecycleStatus.inactive;
    final now = DateTime.now();
    if (now.isAfter(endsAt)) return OfferLifecycleStatus.expired;
    if (now.isBefore(startsAt)) return OfferLifecycleStatus.scheduled;
    return OfferLifecycleStatus.live;
  }

  bool get isExpired => lifecycleStatus == OfferLifecycleStatus.expired;

  @override
  List<Object?> get props => [
        id,
        businessId,
        title,
        slug,
        titleI18n,
        description,
        descriptionI18n,
        seoTitle,
        seoDescription,
        seoTitleI18n,
        seoDescriptionI18n,
        localizedSlugs,
        items,
        productIds,
        durationDays,
        startsAt,
        endsAt,
        discountPercent,
        active,
      ];
}
