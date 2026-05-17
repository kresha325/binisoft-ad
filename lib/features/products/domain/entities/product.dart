import 'package:equatable/equatable.dart';

enum ProductStatus { draft, active, archived }

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
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final List<String> categoryIds;
  final List<String> imageUrls;
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
        categoryIds,
        imageUrls,
        basePrice,
        baseQuantity,
        attributeData,
        nameI18n,
        descriptionI18n,
      ];
}
