import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/contest.dart';
import '../../domain/entities/contest_entry.dart';

final contestsListProvider = StreamProvider.autoDispose<List<Contest>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref.watch(contestRepositoryProvider).watchList(
        businessId: businessId,
        displayLocale: locale,
      );
});

final contestEntriesProvider =
    StreamProvider.autoDispose.family<List<ContestEntry>, String>((ref, contestId) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(contestRepositoryProvider).watchEntries(
        businessId: businessId,
        contestId: contestId,
      );
});
