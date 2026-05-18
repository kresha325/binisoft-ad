import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../orders/data/models/api_key_model.dart';
import '../../data/superadmin_repository.dart';
import '../../domain/superadmin_models.dart';

final superAdminRepositoryProvider = Provider<SuperAdminRepository>((ref) {
  return SuperAdminRepository(firestore: ref.watch(firestoreProvider));
});

final superAdminUsersProvider = FutureProvider<List<SuperAdminUserRow>>((ref) {
  return ref.watch(superAdminRepositoryProvider).listAllUsers();
});

final superAdminBusinessesProvider =
    FutureProvider<List<SuperAdminBusinessRow>>((ref) {
  return ref.watch(superAdminRepositoryProvider).listAllBusinesses();
});

final superAdminProductsProvider =
    FutureProvider<List<SuperAdminProductRow>>((ref) {
  return ref.watch(superAdminRepositoryProvider).listAllProducts();
});

final superAdminCategoriesProvider =
    FutureProvider<List<SuperAdminCategoryRow>>((ref) {
  return ref.watch(superAdminRepositoryProvider).listAllCategories();
});

final superAdminOffersProvider =
    FutureProvider<List<SuperAdminOfferRow>>((ref) {
  return ref.watch(superAdminRepositoryProvider).listAllOffers();
});

/// API keys for a business (superadmin shop integration).
final superAdminBusinessApiKeysProvider =
    StreamProvider.family<List<BusinessApiKeyRecord>, String>((ref, businessId) {
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(apiKeyRepositoryProvider).watchKeys(businessId: businessId);
});
