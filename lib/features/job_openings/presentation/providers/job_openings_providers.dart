import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/job_application.dart';
import '../../domain/entities/job_opening.dart';

final jobOpeningsListProvider = StreamProvider.autoDispose<List<JobOpening>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref.watch(jobOpeningRepositoryProvider).watchList(
        businessId: businessId,
        displayLocale: locale,
      );
});

final jobApplicationsProvider =
    StreamProvider.autoDispose.family<List<JobApplication>, String>((ref, jobOpeningId) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(jobOpeningRepositoryProvider).watchApplications(
        businessId: businessId,
        jobOpeningId: jobOpeningId,
      );
});
