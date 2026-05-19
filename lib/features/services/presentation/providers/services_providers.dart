import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/business_service.dart';

final servicesListProvider =
    StreamProvider.autoDispose<List<BusinessService>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref
      .watch(serviceRepositoryProvider)
      .watchList(businessId: businessId, displayLocale: locale);
});

/// Active services for pickers (e.g. reservations).
final activeServicesListProvider =
    Provider.autoDispose<List<BusinessService>>((ref) {
  final list = ref.watch(servicesListProvider).valueOrNull ?? [];
  return list.where((s) => s.active).toList();
});
