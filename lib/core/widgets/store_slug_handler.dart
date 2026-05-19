import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../constants/user_roles.dart';
import '../providers/firebase_providers.dart';
import '../utils/provider_scope_reader.dart';

/// When URL contains `?store=slug`, switches the active business after login.
class StoreSlugHandler extends ConsumerStatefulWidget {
  const StoreSlugHandler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<StoreSlugHandler> createState() => _StoreSlugHandlerState();
}

class _StoreSlugHandlerState extends ConsumerState<StoreSlugHandler> {
  String? _lastHandled;
  ProviderSubscription<AsyncValue<dynamic>>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = ref.listenManual(
      authStateProvider,
      (_, next) {
        final slug = GoRouterState.of(context).uri.queryParameters['store'];
        _applyStoreSlug(slug, next.valueOrNull);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final slug = GoRouterState.of(context).uri.queryParameters['store'];
      final profile = ref.read(authStateProvider).valueOrNull;
      _applyStoreSlug(slug, profile);
    });
  }

  @override
  void dispose() {
    _authSub?.close();
    super.dispose();
  }

  Future<void> _applyStoreSlug(String? slug, dynamic profile) async {
    if (slug == null || slug.isEmpty || profile == null) return;
    if (_lastHandled == slug) return;

    final providers = providerScopeOf(context);
    final business = await providers.read(businessRepositoryProvider).getBySlug(slug);
    if (business == null || !mounted) return;

    final uid = providers.read(authRepositoryProvider).currentFirebaseUser?.uid;
    if (uid == null) return;

    final isStaff =
        profile.role == UserRole.manager || profile.role == UserRole.employee;

    if (isStaff) {
      if (profile.businessId == business.id) {
        _lastHandled = slug;
      }
      return;
    }

    if (business.ownerId != uid) return;
    if (profile.businessId == business.id) {
      _lastHandled = slug;
      return;
    }

    try {
      await providers.read(authControllerProvider.notifier).switchBusiness(business.id);
      if (!mounted) return;
      _lastHandled = slug;
    } catch (_) {
      // Ignore — user may not own this slug.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
