import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/business_service.dart';
import '../models/service_model.dart';

class ServiceRepository {
  ServiceRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Future<List<BusinessService>> list({
    required String businessId,
    String displayLocale = 'sq',
  }) async {
    final snap = await _paths.services(businessId).orderBy('order').get();
    return snap.docs
        .map((d) =>
            ServiceModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
        .toList();
  }

  Stream<List<BusinessService>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _paths
        .services(businessId)
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ServiceModel.fromFirestore(d, displayLocale: displayLocale)
                  .toEntity())
              .toList(),
        );
  }

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeServiceId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _paths
        .services(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeServiceId != null && doc.id == excludeServiceId) continue;
      return true;
    }
    return false;
  }

  Future<BusinessService> create({
    required String businessId,
    required String name,
    required String slug,
    String? description,
    int? durationMinutes,
    double? priceEur,
    bool active = true,
    int order = 0,
    Map<String, String> nameI18n = const {},
    Map<String, String> descriptionI18n = const {},
  }) async {
    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another service.');
    }

    final ref = _paths.services(businessId).doc();
    final model = ServiceModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      slug: internalSlug,
      order: order,
      description: description,
      durationMinutes: durationMinutes,
      priceEur: priceEur,
      active: active,
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
    );
    await ref.set(model.toMap());
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required BusinessService service,
  }) async {
    final model = ServiceModel(
      id: service.id,
      businessId: businessId,
      name: service.name,
      slug: service.slug,
      order: service.order,
      description: service.description,
      durationMinutes: service.durationMinutes,
      priceEur: service.priceEur,
      active: service.active,
      nameI18n: service.nameI18n,
      descriptionI18n: service.descriptionI18n,
    );
    await _paths.services(businessId).doc(service.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String serviceId,
  }) async {
    await _paths.services(businessId).doc(serviceId).delete();
  }
}
