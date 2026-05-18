import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/product_variant.dart';
import '../models/product_variant_model.dart';

class VariantRepository {
  VariantRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final FirebaseFirestore _firestore;
  final TenantPaths _paths;

  Stream<List<ProductVariant>> watchByProduct({
    required String businessId,
    required String productId,
  }) {
    return _paths
        .productVariants(businessId)
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ProductVariantModel.fromFirestore(d).toEntity())
              .toList()
            ..sort((a, b) => a.sku.compareTo(b.sku)),
        );
  }

  Future<List<ProductVariant>> listByProduct({
    required String businessId,
    required String productId,
  }) async {
    final snap = await _paths
        .productVariants(businessId)
        .where('productId', isEqualTo: productId)
        .get();
    final items = snap.docs
        .map((d) => ProductVariantModel.fromFirestore(d).toEntity())
        .toList();
    items.sort((a, b) => a.sku.compareTo(b.sku));
    return items;
  }

  Future<void> replaceAllForProduct({
    required String businessId,
    required String productId,
    required List<ProductVariant> variants,
  }) async {
    final col = _paths.productVariants(businessId);
    final existing = await col.where('productId', isEqualTo: productId).get();

    final batch = _firestore.batch();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final variant in variants) {
      final ref = variant.id.isNotEmpty ? col.doc(variant.id) : col.doc();
      batch.set(
        ref,
        ProductVariantModel.fromEntity(
          ProductVariant(
            id: ref.id,
            productId: productId,
            businessId: businessId,
            sku: variant.sku,
            price: variant.price,
            quantity: variant.quantity,
            imageUrl: variant.imageUrl,
            attributes: variant.attributes,
          ),
        ).toMap(),
      );
    }
    await batch.commit();
  }

  Future<void> deleteAllForProduct({
    required String businessId,
    required String productId,
  }) async {
    final snap =
        await _paths.productVariants(businessId).where('productId', isEqualTo: productId).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
