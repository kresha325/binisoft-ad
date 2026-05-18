import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.order,
    this.parentId,
    this.description,
    this.seoTitle,
    this.seoDescription,
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
  final int order;
  final String? parentId;
  final String? description;
  final String? seoTitle;
  final String? seoDescription;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> seoTitleI18n;
  final Map<String, String> seoDescriptionI18n;
  final Map<String, String> localizedSlugs;

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        slug,
        order,
        parentId,
        description,
        seoTitle,
        seoDescription,
        nameI18n,
        descriptionI18n,
        seoTitleI18n,
        seoDescriptionI18n,
        localizedSlugs,
      ];
}
