import 'package:equatable/equatable.dart';

import 'product_image.dart';

enum ProductStatus { draft, active, archived }

const int kMaxProductImages = 10;

class Product extends Equatable {
  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.seoTitle,
    this.seoDescription,
    this.categoryIds = const [],
    this.images = const [],
    this.basePrice,
    this.baseQuantity = 0,
    this.attributeData = const {},
    this.nameI18n = const {},
    this.descriptionI18n = const {},
    this.seoTitleI18n = const {},
    this.seoDescriptionI18n = const {},
    this.localizedSlugs = const {},
    this.hiddenByOfferId,
  });

  /// Set while product is exclusive to a live offer (catalog status → draft).
  final String? hiddenByOfferId;

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? seoTitle;
  final String? seoDescription;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> seoTitleI18n;
  final Map<String, String> seoDescriptionI18n;
  final Map<String, String> localizedSlugs;
  final List<String> categoryIds;
  final List<ProductImage> images;

  /// Active images only (public API & shop).
  List<String> get imageUrls =>
      images.where((i) => i.active).map((i) => i.url).toList();
  final double? basePrice;
  final int baseQuantity;
  final Map<String, dynamic> attributeData;

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        slug,
        status,
        createdAt,
        updatedAt,
        description,
        seoTitle,
        seoDescription,
        categoryIds,
        images,
        basePrice,
        baseQuantity,
        attributeData,
        nameI18n,
        descriptionI18n,
        seoTitleI18n,
        seoDescriptionI18n,
        localizedSlugs,
        hiddenByOfferId,
      ];

  bool get isOnOfferHold => hiddenByOfferId != null && hiddenByOfferId!.isNotEmpty;
}
