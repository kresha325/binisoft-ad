import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepository {
  CategoryRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Future<List<Category>> list({
    required String businessId,
    String displayLocale = 'sq',
  }) async {
    final snap = await _paths
        .categories(businessId)
        .orderBy('order')
        .get();
    return snap.docs
        .map((d) => CategoryModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
        .toList();
  }

  Stream<List<Category>> watchList({
    required String businessId,
    String displayLocale = 'sq',
  }) {
    return _paths
        .categories(businessId)
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) =>
                  CategoryModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
              .toList(),
        );
  }

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeCategoryId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _paths
        .categories(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeCategoryId != null && doc.id == excludeCategoryId) continue;
      return true;
    }
    return false;
  }

  Future<Category> create({
    required String businessId,
    required String name,
    required String slug,
    String? description,
    String? seoTitle,
    String? seoDescription,
    String? parentId,
    int order = 0,
    Map<String, String> nameI18n = const {},
    Map<String, String> descriptionI18n = const {},
    Map<String, String> seoTitleI18n = const {},
    Map<String, String> seoDescriptionI18n = const {},
    Map<String, String> localizedSlugs = const {},
  }) async {
    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another category.');
    }

    final ref = _paths.categories(businessId).doc();
    final model = CategoryModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      slug: internalSlug,
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
    await ref.set(model.toMap());
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required Category category,
  }) async {
    final model = CategoryModel(
      id: category.id,
      businessId: businessId,
      name: category.name,
      slug: category.slug,
      order: category.order,
      parentId: category.parentId,
      description: category.description,
      seoTitle: category.seoTitle,
      seoDescription: category.seoDescription,
      nameI18n: category.nameI18n,
      descriptionI18n: category.descriptionI18n,
      seoTitleI18n: category.seoTitleI18n,
      seoDescriptionI18n: category.seoDescriptionI18n,
      localizedSlugs: category.localizedSlugs,
    );
    await _paths.categories(businessId).doc(category.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String categoryId,
  }) async {
    await _paths.categories(businessId).doc(categoryId).delete();
  }
}
