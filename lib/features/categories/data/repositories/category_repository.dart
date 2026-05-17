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

  Future<Category> create({
    required String businessId,
    required String name,
    String? description,
    String? parentId,
    int order = 0,
    Map<String, String> nameI18n = const {},
    Map<String, String> descriptionI18n = const {},
  }) async {
    final ref = _paths.categories(businessId).doc();
    final model = CategoryModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      slug: slugify(name),
      order: order,
      parentId: parentId,
      description: description,
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
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
      nameI18n: category.nameI18n,
      descriptionI18n: category.descriptionI18n,
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
