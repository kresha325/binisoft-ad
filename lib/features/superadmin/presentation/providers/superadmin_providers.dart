import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
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
