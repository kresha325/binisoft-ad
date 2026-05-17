import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/firestore/tenant_paths.dart';
import '../../../../core/utils/slug.dart';
import '../../domain/entities/product.dart';
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

  Future<Product> create({
    required String businessId,
    required String name,
    int? maxProducts,
    String? description,
    Map<String, String> nameI18n = const {},
    Map<String, String> descriptionI18n = const {},
    ProductStatus status = ProductStatus.draft,
    List<String> categoryIds = const [],
    List<String> imageUrls = const [],
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

    final now = DateTime.now();
    final ref = _paths.products(businessId).doc();
    final model = ProductModel(
      id: ref.id,
      businessId: businessId,
      name: name,
      slug: slugify(name),
      status: status.name,
      createdAt: now,
      updatedAt: now,
      description: description,
      categoryIds: categoryIds,
      imageUrls: imageUrls,
      basePrice: basePrice,
      baseQuantity: baseQuantity,
      attributeData: attributeData,
      nameI18n: nameI18n,
      descriptionI18n: descriptionI18n,
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
      categoryIds: product.categoryIds,
      imageUrls: product.imageUrls,
      basePrice: product.basePrice,
      baseQuantity: product.baseQuantity,
      attributeData: product.attributeData,
      nameI18n: product.nameI18n,
      descriptionI18n: product.descriptionI18n,
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
