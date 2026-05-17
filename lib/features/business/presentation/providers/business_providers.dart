import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../domain/entities/business.dart';

final currentBusinessProvider = FutureProvider<Business?>((ref) async {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return null;
  return ref.watch(businessRepositoryProvider).getById(businessId);
});

final ownedBusinessesProvider = FutureProvider<List<Business>>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return [];
  return ref.watch(businessRepositoryProvider).listOwnedBy(user.id);
});

/// Business count + plan limit; derived from [ownedBusinessesProvider] (single source).
final businessQuotaProvider = FutureProvider<BusinessQuota>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) {
    return const BusinessQuota(owned: 0, max: 1, canCreateMore: false);
  }
  final businesses = await ref.watch(ownedBusinessesProvider.future);
  final owned = businesses.length;
  return BusinessQuota(
    owned: owned,
    max: user.maxBusinesses,
    canCreateMore: owned < user.maxBusinesses,
  );
});

class BusinessQuota {
  const BusinessQuota({
    required this.owned,
    required this.max,
    required this.canCreateMore,
  });

  final int owned;
  final int max;
  final bool canCreateMore;

  String get label => '$owned / $max businesses';

  /// Compact usage for header chips, e.g. `2/100`.
  String get usageLabel => '$owned/$max';
}
