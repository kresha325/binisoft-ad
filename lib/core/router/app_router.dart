import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/firebase_providers.dart';
import '../../features/api_docs/presentation/screens/api_docs_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/join_team_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import 'router_refresh_notifier.dart';
import '../../features/business/presentation/screens/businesses_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/dashboard/presentation/screens/business_reports_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/products/presentation/screens/custom_fields_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/billing/presentation/screens/superadmin_invoices_screen.dart';
import '../../features/billing/presentation/screens/superadmin_reports_screen.dart';
import '../../features/billing/presentation/screens/user_invoices_screen.dart';
import '../../features/superadmin/presentation/screens/superadmin_api_screen.dart';
import '../../features/superadmin/presentation/screens/superadmin_cards_screen.dart';
import '../../features/superadmin/presentation/screens/superadmin_screen.dart';
import '../auth/platform_admin.dart';
import '../constants/user_roles.dart';
import '../widgets/admin_shell.dart';
import '../widgets/platform_admin_redirect_gate.dart';
import '../widgets/superadmin_shell.dart';
import '../l10n/l10n_extension.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshNotifierProvider);

  final router = GoRouter(
    // Web admin demo: open login directly (lighter than marketing landing).
    initialLocation: '/login',
    refreshListenable: refresh,
    errorBuilder: (context, state) {
      final l10n = context.l10n;
      return Scaffold(
        backgroundColor: const Color(0xFF0F1A33),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.routerPageNotFound('${state.uri}'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ),
      );
    },
    redirect: (context, state) {
      final authRepo = ref.read(authRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final firebaseUser = authRepo.currentFirebaseUser;
      final firebaseSignedIn = firebaseUser != null;
      final location = state.uri.path;
      final isAuthRoute =
          location == '/login' || location == '/register' || location == '/join';
      final isLanding = location == '/';
      final isSuperAdminRoute = location.startsWith('/superadmin');

      if (!kIsWeb && isLanding) return '/login';

      if (!firebaseSignedIn) {
        if (!isAuthRoute && !(kIsWeb && isLanding)) {
          return kIsWeb ? '/' : '/login';
        }
        return null;
      }

      final profile = authState.valueOrNull;
      final platformAdmin = isPlatformAdmin(
        firebaseUser: firebaseUser,
        profile: profile,
      );

      if (isLanding) {
        if (authState.isLoading || authState.isRefreshing) return null;
        if (profile == null && firebaseSignedIn) return null;
        if (platformAdmin) return '/superadmin';
        if (profile != null) {
          final needsBusiness = profile.businessId.isEmpty;
          return needsBusiness ? '/businesses' : '/dashboard';
        }
        return null;
      }

      if (platformAdmin) {
        if (!isSuperAdminRoute) return '/superadmin';
        return null;
      }

      if (authState.isLoading || authState.isRefreshing) return null;

      // Firebase OK but Firestore profile still syncing (common on iOS after sign-in).
      if (profile == null && firebaseSignedIn) {
        return null;
      }

      if (profile == null) {
        if (!isAuthRoute) return '/login';
        return null;
      }

      if (isSuperAdminRoute) return '/dashboard';

      final needsBusiness =
          profile.businessId.isEmpty && location != '/businesses';

      if (isAuthRoute) {
        return needsBusiness ? '/businesses' : '/dashboard';
      }
      if (needsBusiness) {
        final isStaff =
            profile.role == UserRole.manager || profile.role == UserRole.employee;
        return isStaff ? '/login' : '/businesses';
      }

      if (profile.role == UserRole.employee) {
        const allowed = {'/dashboard', '/orders', '/products'};
        if (!allowed.contains(location)) return '/dashboard';
      } else if (profile.role == UserRole.manager) {
        const blocked = {
          '/businesses',
          '/billing',
          '/api-docs',
          '/settings',
          '/custom-fields',
        };
        if (blocked.contains(location)) return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const LandingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/join', builder: (_, __) => const JoinTeamScreen()),
      GoRoute(
        path: '/superadmin/reports',
        builder: (_, state) => SuperAdminShell(
          child: SuperAdminReportsScreen(
            initialTab: state.uri.queryParameters['tab'],
          ),
        ),
      ),
      GoRoute(
        path: '/superadmin/invoices',
        builder: (_, state) => SuperAdminShell(
          child: SuperAdminInvoicesScreen(
            initialTab: state.uri.queryParameters['tab'],
          ),
        ),
      ),
      GoRoute(
        path: '/superadmin/api',
        builder: (_, __) => const SuperAdminShell(
          child: SuperAdminApiScreen(),
        ),
      ),
      GoRoute(
        path: '/superadmin/cards',
        builder: (_, __) => const SuperAdminShell(
          child: SuperAdminCardsScreen(),
        ),
      ),
      GoRoute(
        path: '/superadmin',
        builder: (_, __) => const SuperAdminShell(
          child: SuperAdminScreen(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => PlatformAdminRedirectGate(
          child: AdminShell(child: child),
        ),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(
            path: '/orders',
            builder: (_, state) => OrdersScreen(
              view: state.uri.queryParameters['view'],
            ),
          ),
          GoRoute(path: '/reports', builder: (_, __) => const BusinessReportsScreen()),
          GoRoute(path: '/businesses', builder: (_, __) => const BusinessesScreen()),
          GoRoute(path: '/products', builder: (_, __) => const ProductsScreen()),
          GoRoute(path: '/categories', builder: (_, __) => const CategoriesScreen()),
          GoRoute(path: '/offers', builder: (_, __) => const OffersScreen()),
          GoRoute(path: '/custom-fields', builder: (_, __) => const CustomFieldsScreen()),
          GoRoute(path: '/api-docs', builder: (_, __) => const ApiDocsScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/billing', builder: (_, __) => const UserInvoicesScreen()),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
