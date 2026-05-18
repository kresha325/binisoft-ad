import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/product_variant.dart';

final productVariantsProvider =
    StreamProvider.autoDispose.family<List<ProductVariant>, String>((ref, productId) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null || productId.isEmpty) return Stream.value([]);
  return ref.watch(variantRepositoryProvider).watchByProduct(
        businessId: businessId,
        productId: productId,
      );
});
