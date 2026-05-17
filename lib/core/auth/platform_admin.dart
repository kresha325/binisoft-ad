import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../constants/superadmin_config.dart';

/// Platform superadmin (bootstrap email or Firestore role).
bool isPlatformAdmin({
  required User? firebaseUser,
  AppUser? profile,
}) {
  final authEmail = firebaseUser?.email;
  if (authEmail != null && SuperAdminConfig.isBootstrapEmail(authEmail)) {
    return true;
  }
  if (profile != null) {
    if (profile.isSuperAdmin) return true;
    if (SuperAdminConfig.isBootstrapEmail(profile.email)) return true;
  }
  return false;
}
