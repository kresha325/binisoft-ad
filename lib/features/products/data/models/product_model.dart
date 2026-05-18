import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_image.dart';

List<ProductImage> _parseImages(Map<String, dynamic> data) {
  final fromImages = ProductImage.fromFirestoreList(data['images']);
  if (fromImages.isNotEmpty) return fromImages;
  return ProductImage.fromUrlList(
    List<String>.from(data['imageUrls'] as List? ?? []),
  );
}

String? _readOptionalString(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

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

class ProductModel {
  ProductModel({
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
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? seoTitle;
  final String? seoDescription;
  final List<String> categoryIds;
  final List<ProductImage> images;
  final double? basePrice;
  final int baseQuantity;
  final Map<String, dynamic> attributeData;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> seoTitleI18n;
  final Map<String, String> seoDescriptionI18n;
  final Map<String, String> localizedSlugs;

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
    final seoTitleI18n = LocalizedText.parseMap(data['seoTitleI18n']);
    final seoDescriptionI18n = LocalizedText.parseMap(data['seoDescriptionI18n']);
    final localizedSlugs = LocalizedText.parseMap(data['localizedSlugs']);
    return ProductModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      name: LocalizedText.resolve(
        primary: data['name'],
        i18n: nameI18n,
        locale: displayLocale,
        defaultLocale: displayLocale,
      ),
      slug: data['slug'] as String,
      status: data['status'] as String? ?? 'draft',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      description: _readOptionalString(data, 'description') ??
          _readOptionalString(data, 'desc'),
      seoTitle: _optionalLocalized(data, 'seoTitle', 'seoTitleI18n', displayLocale),
      seoDescription:
          _optionalLocalized(data, 'seoDescription', 'seoDescriptionI18n', displayLocale),
      categoryIds: List<String>.from(data['categoryIds'] as List? ?? []),
      images: _parseImages(data),
      basePrice: (data['basePrice'] as num?)?.toDouble(),
      baseQuantity: data['baseQuantity'] as int? ?? 0,
      attributeData: Map<String, dynamic>.from(data['attributeData'] as Map? ?? {}),
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
      seoTitleI18n: seoTitleI18n,
      seoDescriptionI18n: seoDescriptionI18n,
    );
  }

  Map<String, dynamic> toMap() => {
        'businessId': businessId,
        'name': name,
        'slug': slug,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'description': description ?? '',
        'categoryIds': categoryIds,
        'images': images.map((i) => i.toMap()).toList(),
        'imageUrls': images.where((i) => i.active).map((i) => i.url).toList(),
        if (basePrice != null) 'basePrice': basePrice,
        'baseQuantity': baseQuantity,
        'attributeData': attributeData,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
        if (seoTitle != null && seoTitle!.isNotEmpty) 'seoTitle': seoTitle,
        if (seoDescription != null && seoDescription!.isNotEmpty) 'seoDescription': seoDescription,
        if (seoTitleI18n.isNotEmpty) 'seoTitleI18n': seoTitleI18n,
        if (seoDescriptionI18n.isNotEmpty) 'seoDescriptionI18n': seoDescriptionI18n,
        if (localizedSlugs.isNotEmpty) 'localizedSlugs': localizedSlugs,
      };

  Product toEntity() => Product(
        id: id,
        businessId: businessId,
        name: name,
        slug: slug,
        status: ProductStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => ProductStatus.draft,
        ),
        createdAt: createdAt,
        updatedAt: updatedAt,
        description: description,
        seoTitle: seoTitle,
        seoDescription: seoDescription,
        categoryIds: categoryIds,
        images: images,
        basePrice: basePrice,
        baseQuantity: baseQuantity,
        attributeData: attributeData,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
        seoTitleI18n: seoTitleI18n,
        seoDescriptionI18n: seoDescriptionI18n,
        localizedSlugs: localizedSlugs,
      );
}
