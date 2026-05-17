import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/category.dart';

final categoriesListProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref
      .watch(categoryRepositoryProvider)
      .watchList(businessId: businessId, displayLocale: locale);
});
