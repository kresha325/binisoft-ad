import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/category.dart';

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

class CategoryModel {
  CategoryModel({
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

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
    final seoTitleI18n = LocalizedText.parseMap(data['seoTitleI18n']);
    final seoDescriptionI18n = LocalizedText.parseMap(data['seoDescriptionI18n']);
    final localizedSlugs = LocalizedText.parseMap(data['localizedSlugs']);
    return CategoryModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      name: LocalizedText.resolve(
        primary: data['name'],
        i18n: nameI18n,
        locale: displayLocale,
        defaultLocale: displayLocale,
      ),
      slug: data['slug'] as String,
      order: data['order'] as int? ?? 0,
      parentId: data['parentId'] as String?,
      description: _optionalLocalized(data, 'description', 'descriptionI18n', displayLocale),
      seoTitle: _optionalLocalized(data, 'seoTitle', 'seoTitleI18n', displayLocale),
      seoDescription:
          _optionalLocalized(data, 'seoDescription', 'seoDescriptionI18n', displayLocale),
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
      seoTitleI18n: seoTitleI18n,
      seoDescriptionI18n: seoDescriptionI18n,
      localizedSlugs: localizedSlugs,
    );
  }

  Map<String, dynamic> toMap() => {
        'businessId': businessId,
        'name': name,
        'slug': slug,
        'order': order,
        if (parentId != null) 'parentId': parentId,
        if (description != null && description!.isNotEmpty) 'description': description,
        if (seoTitle != null && seoTitle!.isNotEmpty) 'seoTitle': seoTitle,
        if (seoDescription != null && seoDescription!.isNotEmpty) 'seoDescription': seoDescription,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
        if (seoTitleI18n.isNotEmpty) 'seoTitleI18n': seoTitleI18n,
        if (seoDescriptionI18n.isNotEmpty) 'seoDescriptionI18n': seoDescriptionI18n,
        if (localizedSlugs.isNotEmpty) 'localizedSlugs': localizedSlugs,
      };

  Category toEntity() => Category(
        id: id,
        businessId: businessId,
        name: name,
        slug: slug,
        order: order,
        parentId: parentId,
        description: description,
        seoTitle: seoTitle,
        seoDescription: seoDescription,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
        seoTitleI18n: seoTitleI18n,
        seoDescriptionI18n: seoDescriptionI18n,
        localizedSlugs: localizedSlugs,
      );
}
