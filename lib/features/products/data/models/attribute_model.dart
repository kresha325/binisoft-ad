import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/attribute_definition.dart';

class AttributeModel {
  AttributeModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.key,
    required this.type,
    required this.required,
    this.options = const [],
    this.active = true,
    this.nameI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String key;
  final String type;
  final bool required;
  final List<String> options;
  final bool active;
  final Map<String, String> nameI18n;

  factory AttributeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = AppLocales.defaultLocale,
  }) {
    final data = doc.data()!;
    final nameI18n = LocalizedText.parseMap(data['nameI18n']);
    final resolvedName = LocalizedText.resolve(
      primary: data['name'],
      i18n: nameI18n,
      locale: displayLocale,
      defaultLocale: displayLocale,
    );
    return AttributeModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      name: resolvedName,
      key: data['key'] as String? ?? resolvedName,
      type: data['type'] as String? ?? 'text',
      required: data['required'] as bool? ?? false,
      options: List<String>.from(data['options'] as List? ?? []),
      active: data['active'] as bool? ?? true,
      nameI18n: nameI18n,
    );
  }

  Map<String, dynamic> toMap() => {
        'businessId': businessId,
        'name': name,
        'key': key,
        'type': type,
        'required': required,
        'options': options,
        'active': active,
        if (nameI18n.isNotEmpty) 'nameI18n': nameI18n,
      };

  AttributeDefinition toEntity() => AttributeDefinition(
        id: id,
        businessId: businessId,
        name: name,
        key: key,
        type: AttributeType.values.firstWhere(
          (t) => t.name == type,
          orElse: () => AttributeType.text,
        ),
        required: required,
        options: options,
        active: active,
        nameI18n: nameI18n,
      );
}
