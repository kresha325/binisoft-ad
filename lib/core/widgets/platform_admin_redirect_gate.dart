import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../auth/platform_admin.dart';
import '../providers/firebase_providers.dart';

/// Blocks business admin UI for platform superadmins and sends them to `/superadmin`.
class PlatformAdminRedirectGate extends ConsumerStatefulWidget {
  const PlatformAdminRedirectGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PlatformAdminRedirectGate> createState() =>
      _PlatformAdminRedirectGateState();
}

class _PlatformAdminRedirectGateState extends ConsumerState<PlatformAdminRedirectGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfNeeded());
  }

  @override
  void didUpdateWidget(covariant PlatformAdminRedirectGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfNeeded());
  }

  void _redirectIfNeeded() {
    if (!mounted) return;
    final firebaseUser = ref.read(authRepositoryProvider).currentFirebaseUser;
    final profile = ref.read(authStateProvider).valueOrNull;
    if (!isPlatformAdmin(firebaseUser: firebaseUser, profile: profile)) {
      return;
    }
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/superadmin')) return;
    context.go('/superadmin');
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = ref.watch(authRepositoryProvider).currentFirebaseUser;
    final profile = ref.watch(authStateProvider).valueOrNull;
    final blocked = isPlatformAdmin(firebaseUser: firebaseUser, profile: profile);
    final onSuperAdmin = GoRouterState.of(context).uri.path.startsWith('/superadmin');

    if (blocked && !onSuperAdmin) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.child;
  }
}
