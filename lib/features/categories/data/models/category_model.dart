import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/category.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.order,
    this.parentId,
    this.description,
    this.nameI18n = const {},
    this.descriptionI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final int order;
  final String? parentId;
  final String? description;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
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
      description: data['description'] as String?,
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
    );
  }

  Map<String, dynamic> toMap() => {
        'businessId': businessId,
        'name': name,
        'slug': slug,
        'order': order,
        if (parentId != null) 'parentId': parentId,
        if (description != null && description!.isNotEmpty) 'description': description,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
      };

  Category toEntity() => Category(
        id: id,
        businessId: businessId,
        name: name,
        slug: slug,
        order: order,
        parentId: parentId,
        description: description,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
      );
}
