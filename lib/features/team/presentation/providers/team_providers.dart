import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/staff_api_service.dart';
import '../../data/team_repository.dart';
import '../../domain/team_member.dart';

final staffApiServiceProvider = Provider<StaffApiService>((ref) {
  return StaffApiService(auth: ref.watch(firebaseAuthProvider));
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(firestore: ref.watch(firestoreProvider));
});

final teamMembersProvider = StreamProvider.autoDispose<List<TeamMember>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(teamRepositoryProvider).watchMembers(businessId);
});
