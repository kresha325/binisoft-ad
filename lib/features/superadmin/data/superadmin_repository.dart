import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/firestore/tenant_paths.dart';
import '../../../core/services/superadmin_service.dart';
import '../../auth/data/models/app_user_model.dart';
import '../../business/data/models/business_model.dart';
import '../../categories/data/models/category_model.dart';
import '../../offers/data/models/offer_model.dart';
import '../../products/data/models/product_model.dart';
import '../domain/superadmin_models.dart';

class SuperAdminRepository {
  SuperAdminRepository({
    FirebaseFirestore? firestore,
    SuperAdminService? superAdminService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _paths = TenantPaths(firestore ?? FirebaseFirestore.instance),
        _superAdminService = superAdminService ?? SuperAdminService();

  final FirebaseFirestore _firestore;
  final TenantPaths _paths;
  final SuperAdminService _superAdminService;

  Future<List<SuperAdminUserRow>> listAllUsers() async {
    final snap = await _firestore.collection(FirestoreCollections.users).get();
    final rows = snap.docs.map((doc) {
      final model = AppUserModel.fromFirestore(doc);
      return SuperAdminUserRow(
        id: model.id,
        email: model.email,
        role: model.role,
        businessId: model.businessId,
        maxBusinesses: model.maxBusinesses,
        maxProducts: model.maxProducts,
        displayName: model.displayName,
      );
    }).toList();
    rows.sort((a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()));
    return rows;
  }

  Future<List<SuperAdminBusinessRow>> listAllBusinesses() async {
    final snap = await _firestore.collection(FirestoreCollections.businesses).get();
    final rows = snap.docs.map((doc) {
      final b = BusinessModel.fromFirestore(doc);
      return SuperAdminBusinessRow(
        id: b.id,
        name: b.name,
        ownerId: b.ownerId,
        slug: b.slug,
        active: b.active,
        createdAt: b.createdAt,
      );
    }).toList();
    rows.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return rows;
  }

  Future<Map<String, String>> _businessNameMap() async {
    final businessSnap =
        await _firestore.collection(FirestoreCollections.businesses).get();
    return {
      for (final d in businessSnap.docs)
        d.id: BusinessModel.fromFirestore(d).name,
    };
  }

  Future<List<SuperAdminProductRow>> listAllProducts({int limit = 2000}) async {
    final businessNames = await _businessNameMap();

    final productSnap = await _firestore
        .collectionGroup(FirestoreCollections.products)
        .limit(limit)
        .get();

    final rows = productSnap.docs.map((doc) {
      final p = ProductModel.fromFirestore(doc);
      final businessId = doc.reference.parent.parent?.id ?? p.businessId;
      return SuperAdminProductRow(
        id: doc.id,
        businessId: businessId,
        businessName: businessNames[businessId] ?? businessId,
        name: p.name,
        status: p.status,
        updatedAt: p.updatedAt,
      );
    }).toList();
    rows.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return rows;
  }

  Future<List<SuperAdminCategoryRow>> listAllCategories({int limit = 2000}) async {
    final businessNames = await _businessNameMap();
    final snap = await _firestore
        .collectionGroup(FirestoreCollections.categories)
        .limit(limit)
        .get();

    final rows = snap.docs.map((doc) {
      final c = CategoryModel.fromFirestore(doc);
      final businessId = doc.reference.parent.parent?.id ?? c.businessId;
      return SuperAdminCategoryRow(
        id: doc.id,
        businessId: businessId,
        businessName: businessNames[businessId] ?? businessId,
        name: c.name,
        slug: c.slug,
      );
    }).toList();
    rows.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return rows;
  }

  Future<List<SuperAdminOfferRow>> listAllOffers({int limit = 2000}) async {
    final businessNames = await _businessNameMap();
    final snap = await _firestore
        .collectionGroup(FirestoreCollections.offers)
        .limit(limit)
        .get();

    final rows = snap.docs.map((doc) {
      final o = OfferModel.fromFirestore(doc);
      final businessId = doc.reference.parent.parent?.id ?? o.businessId;
      return SuperAdminOfferRow(
        id: doc.id,
        businessId: businessId,
        businessName: businessNames[businessId] ?? businessId,
        title: o.title,
        active: o.active,
        itemCount: o.items.length,
        endsAt: o.endsAt,
      );
    }).toList();
    rows.sort((a, b) => b.endsAt.compareTo(a.endsAt));
    return rows;
  }

  Future<void> deleteProduct({
    required String businessId,
    required String productId,
  }) async {
    await _superAdminService.deleteProduct(
      businessId: businessId,
      productId: productId,
    );
  }

  Future<void> deleteCategory({
    required String businessId,
    required String categoryId,
  }) async {
    await _superAdminService.deleteCategory(
      businessId: businessId,
      categoryId: categoryId,
    );
  }

  Future<void> deleteOffer({
    required String businessId,
    required String offerId,
  }) async {
    await _superAdminService.deleteOffer(
      businessId: businessId,
      offerId: offerId,
    );
  }

  Future<void> setBusinessActive({
    required String businessId,
    required bool active,
  }) async {
    await _paths.business(businessId).update({'active': active});
  }

  Future<void> deleteBusiness(String businessId) async {
    await _superAdminService.deleteBusiness(businessId);
  }

  Future<void> deleteUser(String targetUid) async {
    await _superAdminService.deleteUserAccount(targetUid);
  }
}
