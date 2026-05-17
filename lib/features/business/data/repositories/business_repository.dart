import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../models/business_model.dart';
import '../../domain/entities/business.dart';

class BusinessRepository {
  BusinessRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final FirebaseFirestore _firestore;
  final TenantPaths _paths;

  Future<Business?> getById(String businessId) async {
    final doc = await _paths.business(businessId).get();
    if (!doc.exists) return null;
    return BusinessModel.fromFirestore(doc).toEntity();
  }

  Future<List<Business>> listOwnedBy(String ownerId) async {
    final snap = await _firestore
        .collection('businesses')
        .where('ownerId', isEqualTo: ownerId)
        .get();
    final list =
        snap.docs.map((d) => BusinessModel.fromFirestore(d).toEntity()).toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  Future<int> countOwnedBy(String ownerId) async {
    final businesses = await listOwnedBy(ownerId);
    return businesses.length;
  }

  Future<bool> isSlugTaken(String slug) async {
    final businessSlug = slugify(slug);
    if (businessSlug.isEmpty) return false;
    final doc = await _firestore.collection('slugs').doc(businessSlug).get();
    return doc.exists;
  }

  Future<Business> create({
    required String ownerId,
    required String name,
    required String slug,
  }) async {
    final businessSlug = slugify(slug.isNotEmpty ? slug : name);
    if (businessSlug.isEmpty) {
      throw Exception('URL slug is required.');
    }

    final ref = _firestore.collection('businesses').doc();
    final now = DateTime.now();
    final model = BusinessModel(
      id: ref.id,
      name: name.trim(),
      ownerId: ownerId,
      createdAt: now,
      slug: businessSlug,
      active: true,
      defaultLocale: AppLocales.defaultLocale,
      locales: List<String>.from(AppLocales.all),
    );

    await _firestore.runTransaction((tx) async {
      final slugRef = _firestore.collection('slugs').doc(businessSlug);
      if ((await tx.get(slugRef)).exists) {
        throw Exception('This URL slug is already taken. Choose another.');
      }
      tx.set(slugRef, {'businessId': ref.id, 'ownerId': ownerId});
      tx.set(ref, model.toMap());
    });

    return model.toEntity();
  }

  Future<void> updateProfile({
    required String businessId,
    required String name,
    String? description,
    String? logoUrl,
    String? backgroundPresetId,
    String? backgroundImageUrl,
    double? backgroundOverlayOpacity,
    String? orderPhone,
    String? defaultLocale,
    List<String>? locales,
    Map<String, String>? nameI18n,
    Map<String, String>? descriptionI18n,
  }) async {
    await _paths.business(businessId).update({
      'name': name,
      'description': description ?? '',
      'logoUrl': logoUrl ?? '',
      'backgroundPresetId': backgroundPresetId ?? '',
      'backgroundImageUrl': backgroundImageUrl ?? '',
      if (backgroundOverlayOpacity != null)
        'backgroundOverlayOpacity': backgroundOverlayOpacity,
      if (orderPhone != null) 'orderPhone': orderPhone.trim(),
      if (defaultLocale != null) 'defaultLocale': defaultLocale,
      if (locales != null) 'locales': locales,
      if (nameI18n != null) 'nameI18n': nameI18n,
      if (descriptionI18n != null) 'descriptionI18n': descriptionI18n,
    });
  }

  Future<void> updateApiLocales({
    required String businessId,
    required String defaultLocale,
    required List<String> locales,
  }) async {
    await _paths.business(businessId).update({
      'defaultLocale': defaultLocale,
      'locales': AppLocales.normalizeList(locales),
    });
  }

  /// Removes business document and its public slug (subcollections are not deleted).
  Future<void> deleteBusiness(String businessId) async {
    final businessRef = _paths.business(businessId);
    final snap = await businessRef.get();
    if (!snap.exists) return;

    final slug = snap.data()?['slug'] as String?;
    final batch = _firestore.batch();
    batch.delete(businessRef);
    if (slug != null && slug.isNotEmpty) {
      batch.delete(_firestore.collection('slugs').doc(slug));
    }
    await batch.commit();
  }
}
