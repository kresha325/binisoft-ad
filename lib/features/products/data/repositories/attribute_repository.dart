import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/default_attribute_templates.dart';
import '../../domain/entities/attribute_definition.dart';
import '../models/attribute_model.dart';

class AttributeRepository {
  AttributeRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Future<List<AttributeDefinition>> list({
    required String businessId,
    String displayLocale = 'sq',
  }) async {
    final snap = await _paths.attributes(businessId).orderBy('name').get();
    return snap.docs
        .map((d) => AttributeModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
        .toList();
  }

  Stream<List<AttributeDefinition>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _paths
        .attributes(businessId)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) =>
                  AttributeModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
              .toList(),
        );
  }

  Future<AttributeDefinition> create({
    required String businessId,
    required String name,
    required String key,
    required AttributeType type,
    bool required = false,
    bool active = true,
    List<String> options = const [],
    Map<String, String> nameI18n = const {},
  }) async {
    final ref = _paths.attributes(businessId).doc();
    final model = AttributeModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      key: key,
      type: type.name,
      required: required,
      options: options,
      active: active,
      nameI18n: nameI18n,
    );
    await ref.set(model.toMap());
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required AttributeDefinition attribute,
  }) async {
    final model = AttributeModel(
      id: attribute.id,
      businessId: businessId,
      name: attribute.name,
      key: attribute.key,
      type: attribute.type.name,
      required: attribute.required,
      options: attribute.options,
      active: attribute.active,
      nameI18n: attribute.nameI18n,
    );
    await _paths.attributes(businessId).doc(attribute.id).update(model.toMap());
  }

  /// Enables a default template (required + active) or disables it (inactive).
  Future<void> setTemplateEnabled({
    required String businessId,
    required DefaultAttributeTemplate template,
    required bool enabled,
  }) async {
    final items = await list(businessId: businessId);
    final existing = items.where((a) => a.key == template.key).firstOrNull;

    if (enabled) {
      if (existing != null) {
        await update(
          businessId: businessId,
          attribute: existing.copyWith(
            name: template.name,
            type: template.type,
            options: template.options,
            required: true,
            active: true,
          ),
        );
      } else {
        await create(
          businessId: businessId,
          name: template.name,
          key: template.key,
          type: template.type,
          required: true,
          active: true,
          options: template.options,
        );
      }
      return;
    }

    if (existing != null) {
      await update(
        businessId: businessId,
        attribute: existing.copyWith(required: false, active: false),
      );
    }
  }

  Future<void> delete({
    required String businessId,
    required String attributeId,
  }) async {
    await _paths.attributes(businessId).doc(attributeId).delete();
  }
}
