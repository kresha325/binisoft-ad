import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/media_upload_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/business/data/repositories/business_repository.dart';
import '../../features/categories/data/repositories/category_repository.dart';
import '../../features/services/data/repositories/service_repository.dart';
import '../../features/products/data/repositories/attribute_repository.dart';
import '../../features/orders/data/repositories/api_key_repository.dart';
import '../../features/offers/data/repositories/offer_repository.dart';
import '../../features/orders/data/repositories/order_repository.dart';
import '../../features/products/data/repositories/product_repository.dart';
import '../../features/products/data/repositories/variant_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseStorageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider));
});

final variantRepositoryProvider = Provider<VariantRepository>((ref) {
  return VariantRepository(firestore: ref.watch(firestoreProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(firestore: ref.watch(firestoreProvider));
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(firestore: ref.watch(firestoreProvider));
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  return OfferRepository(firestore: ref.watch(firestoreProvider));
});

final attributeRepositoryProvider = Provider<AttributeRepository>((ref) {
  return AttributeRepository(firestore: ref.watch(firestoreProvider));
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepository(firestore: ref.watch(firestoreProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(firestore: ref.watch(firestoreProvider));
});

final apiKeyRepositoryProvider = Provider<ApiKeyRepository>((ref) {
  return ApiKeyRepository(firestore: ref.watch(firestoreProvider));
});

final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  return MediaUploadService(storage: ref.watch(firebaseStorageProvider));
});
