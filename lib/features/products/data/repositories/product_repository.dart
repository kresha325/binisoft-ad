import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_image.dart';
import '../models/product_model.dart';

class ProductPage {
  const ProductPage({required this.items, this.lastDocument});

  final List<Product> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
}

class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Future<ProductPage> list({
    required String businessId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = AppConstants.defaultPageSize,
    ProductStatus? status,
    String displayLocale = 'sq',
  }) async {
    Query<Map<String, dynamic>> query = _paths
        .products(businessId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snap = await query.get();
    final items = snap.docs
        .map((d) => ProductModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
        .toList();
    return ProductPage(
      items: items,
      lastDocument: snap.docs.isEmpty ? null : snap.docs.last,
    );
  }

  Stream<List<Product>> watchList({
    required String businessId,
    int limit = 200,
    String displayLocale = 'sq',
  }) {
    return _paths
        .products(businessId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) =>
                      ProductModel.fromFirestore(d, displayLocale: displayLocale).toEntity())
                  .toList(),
        );
  }

  Future<int> count({required String businessId}) async {
    final snap = await _paths.products(businessId).count().get();
    return snap.count ?? 0;
  }

  Future<Product> getById({
    required String businessId,
    required String productId,
    String displayLocale = 'sq',
  }) async {
    final doc = await _paths.products(businessId).doc(productId).get();
    if (!doc.exists) throw Exception('Product not found');
    return ProductModel.fromFirestore(doc, displayLocale: displayLocale).toEntity();
  }

  Future<bool> isSlugTaken({
    required String businessId,
    required String slug,
    String? excludeProductId,
  }) async {
    final normalized = slugify(slug);
    if (normalized.isEmpty) return false;
    final snap = await _paths
        .products(businessId)
        .where('slug', isEqualTo: normalized)
        .limit(5)
        .get();
    for (final doc in snap.docs) {
      if (excludeProductId != null && doc.id == excludeProductId) continue;
      return true;
    }
    return false;
  }

  Future<Product> create({
    required String businessId,
    required String name,
    required String slug,
    int? maxProducts,
    String? description,
    String? seoTitle,
    String? seoDescription,
    Map<String, String> nameI18n = const {},
    Map<String, String> descriptionI18n = const {},
    Map<String, String> seoTitleI18n = const {},
    Map<String, String> seoDescriptionI18n = const {},
    Map<String, String> localizedSlugs = const {},
    ProductStatus status = ProductStatus.draft,
    List<String> categoryIds = const [],
    List<ProductImage> images = const [],
    double? basePrice,
    int baseQuantity = 0,
    Map<String, dynamic> attributeData = const {},
  }) async {
    if (maxProducts != null) {
      final current = await count(businessId: businessId);
      if (current >= maxProducts) {
        throw AuthException(
          'Product limit reached ($maxProducts). Upgrade your plan to add more.',
        );
      }
    }

    final internalSlug = slugify(slug);
    if (internalSlug.isEmpty) {
      throw Exception('Internal slug is required.');
    }
    if (await isSlugTaken(businessId: businessId, slug: internalSlug)) {
      throw Exception('This internal slug is already used by another product.');
    }

    final now = DateTime.now();
    final ref = _paths.products(businessId).doc();
    final model = ProductModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      slug: internalSlug,
      status: status.name,
      createdAt: now,
      updatedAt: now,
      description: description,
      seoTitle: seoTitle,
      seoDescription: seoDescription,
      categoryIds: categoryIds,
      images: images,
      basePrice: basePrice,
      baseQuantity: baseQuantity,
      attributeData: attributeData,
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
    required Product product,
  }) async {
    final model = ProductModel(
      id: product.id,
      businessId: businessId,
      name: product.name,
      slug: product.slug,
      status: product.status.name,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
      description: product.description,
      seoTitle: product.seoTitle,
      seoDescription: product.seoDescription,
      categoryIds: product.categoryIds,
      images: product.images,
      basePrice: product.basePrice,
      baseQuantity: product.baseQuantity,
      attributeData: product.attributeData,
      nameI18n: product.nameI18n,
      descriptionI18n: product.descriptionI18n,
      seoTitleI18n: product.seoTitleI18n,
      seoDescriptionI18n: product.seoDescriptionI18n,
      localizedSlugs: product.localizedSlugs,
    );
    await _paths.products(businessId).doc(product.id).update(model.toMap());
  }

  Future<void> delete({
    required String businessId,
    required String productId,
  }) async {
    await _paths.products(businessId).doc(productId).delete();
  }
}
