import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/business_permissions.dart';
import '../../../business/presentation/providers/business_providers.dart';
import 'auth_providers.dart';

final businessPermissionsProvider = Provider<BusinessPermissions>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  final business = ref.watch(currentBusinessProvider).valueOrNull;

  if (user == null) return BusinessPermissions.empty;

  final isStoreOwner =
      business != null && business.ownerId == user.id;

  return BusinessPermissions(
    user: user,
    business: business,
    isStoreOwner: isStoreOwner,
  );
});
