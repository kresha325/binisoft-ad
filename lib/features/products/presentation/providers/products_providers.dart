import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/product.dart';

final productsListProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref
      .watch(productRepositoryProvider)
      .watchList(businessId: businessId, displayLocale: locale);
});

/// Product usage vs plan limit for the active business catalog.
final productQuotaProvider = Provider<ProductQuota>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  final products = ref.watch(productsListProvider).valueOrNull ?? [];
  if (user == null) {
    return const ProductQuota(used: 0, max: 0, canCreateMore: false);
  }
  final max = user.maxProducts;
  final used = products.length;
  return ProductQuota(
    used: used,
    max: max,
    canCreateMore: used < max,
  );
});

class ProductQuota {
  const ProductQuota({
    required this.used,
    required this.max,
    required this.canCreateMore,
  });

  final int used;
  final int max;
  final bool canCreateMore;

  String get label => '$used / $max products';

  String get usageLabel => '$used/$max';
}
