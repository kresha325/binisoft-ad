import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/business_service.dart';

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

class ServiceModel {
  ServiceModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.order,
    this.description,
    this.durationMinutes,
    this.priceEur,
    this.active = true,
    this.nameI18n = const {},
    this.descriptionI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final int order;
  final String? description;
  final int? durationMinutes;
  final double? priceEur;
  final bool active;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;

  factory ServiceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final descriptionI18n = LocalizedText.parseMap(data['descriptionI18n']);
    return ServiceModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      name: LocalizedText.resolve(
        primary: data['name'],
        i18n: nameI18n,
        locale: displayLocale,
        defaultLocale: displayLocale,
      ),
      slug: ((data['slug'] as String?)?.trim().isNotEmpty == true)
          ? data['slug'] as String
          : doc.id,
      order: data['order'] as int? ?? 0,
      description:
          _optionalLocalized(data, 'description', 'descriptionI18n', displayLocale),
      durationMinutes: data['durationMinutes'] as int?,
      priceEur: (data['priceEur'] as num?)?.toDouble(),
      active: data['active'] as bool? ?? true,
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
    );
  }

  Map<String, dynamic> toMap() => {
        'businessId': businessId,
        'name': name,
        'slug': slug,
        'order': order,
        'active': active,
        if (description != null && description!.isNotEmpty) 'description': description,
        if (durationMinutes != null) 'durationMinutes': durationMinutes,
        if (priceEur != null) 'priceEur': priceEur,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
        if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
      };

  BusinessService toEntity() => BusinessService(
        id: id,
        businessId: businessId,
        name: name,
        slug: slug,
        order: order,
        description: description,
        durationMinutes: durationMinutes,
        priceEur: priceEur,
        active: active,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
      );
}
