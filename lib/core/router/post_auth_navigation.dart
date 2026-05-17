import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/superadmin_config.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

void navigateAfterAuth(
  GoRouter router,
  AppUser user, {
  String? loginEmail,
}) {
  final email = loginEmail?.trim().toLowerCase() ?? user.email;

  if (SuperAdminConfig.isBootstrapEmail(email) || user.isSuperAdmin) {
    router.go('/superadmin');
    return;
  }

  if (user.businessId.isEmpty) {
    router.go('/businesses');
  } else {
    router.go('/dashboard');
  }
}

Future<void> signOutAndGoToLogin(BuildContext context, WidgetRef ref) async {
  await ref.read(authControllerProvider.notifier).signOut();
  if (!context.mounted) return;
  GoRouter.of(context).go('/login');
}
