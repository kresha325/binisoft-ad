import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/product.dart';

String? _readOptionalString(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
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
    this.categoryIds = const [],
    this.imageUrls = const [],
    this.basePrice,
    this.baseQuantity = 0,
    this.attributeData = const {},
    this.nameI18n = const {},
    this.descriptionI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final List<String> categoryIds;
  final List<String> imageUrls;
  final double? basePrice;
  final int baseQuantity;
  final Map<String, dynamic> attributeData;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
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
      categoryIds: List<String>.from(data['categoryIds'] as List? ?? []),
      imageUrls: List<String>.from(data['imageUrls'] as List? ?? []),
      basePrice: (data['basePrice'] as num?)?.toDouble(),
      baseQuantity: data['baseQuantity'] as int? ?? 0,
      attributeData: Map<String, dynamic>.from(data['attributeData'] as Map? ?? {}),
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
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
        'imageUrls': imageUrls,
        if (basePrice != null) 'basePrice': basePrice,
        'baseQuantity': baseQuantity,
        'attributeData': attributeData,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
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
        categoryIds: categoryIds,
        imageUrls: imageUrls,
        basePrice: basePrice,
        baseQuantity: baseQuantity,
        attributeData: attributeData,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
      );
}
