import 'package:equatable/equatable.dart';

/// How a product price is reduced within an offer.
enum OfferDiscountMode { percent, salePrice }

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

  bool get isCurrentlyActive {
    if (!active) return false;
    final now = DateTime.now();
    return !now.isBefore(startsAt) && !now.isAfter(endsAt);
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        title,
        titleI18n,
        description,
        descriptionI18n,
        items,
        productIds,
        durationDays,
        startsAt,
        endsAt,
        discountPercent,
        active,
      ];
}
