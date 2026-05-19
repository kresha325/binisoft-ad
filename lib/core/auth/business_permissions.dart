import '../../features/auth/domain/entities/app_user.dart';
import '../../features/business/domain/entities/business.dart';
import '../constants/user_roles.dart';

/// Effective permissions for the active store session.
class BusinessPermissions {
  const BusinessPermissions({
    required this.user,
    required this.business,
    required this.isStoreOwner,
  });

  final AppUser? user;
  final Business? business;
  final bool isStoreOwner;

  static const empty = BusinessPermissions(user: null, business: null, isStoreOwner: false);

  UserRole get role => user?.role ?? UserRole.employee;

  bool get isSignedIn => user != null;

  bool get isPlatformAdmin => user?.isSuperAdmin ?? false;

  bool get isStaff => role == UserRole.manager || role == UserRole.employee;

  /// Account owner (multi-store) — not store staff.
  bool get isAccountAdmin =>
      !isStaff && (role == UserRole.admin || role == UserRole.owner || isStoreOwner);

  bool get canWriteCatalog =>
      isStoreOwner || role.canWriteCatalog();

  bool get canManageOrders => user != null && business != null;

  bool get canManageTeam => isStoreOwner || role.canManageUsers();

  bool get canManageApiKeys => isStoreOwner || role.canManageApiKeys();

  bool get canAccessBilling => isAccountAdmin && !isStaff;

  bool get canManageBusinesses => isAccountAdmin && (user?.maxBusinesses ?? 0) > 0;

  bool get canAccessSettings => isStoreOwner || role == UserRole.admin;

  bool get canAccessReports => canWriteCatalog || isStaff;

  bool get canAccessApiDocs => isAccountAdmin;

  bool canAccessRoute(String path) {
    if (path.startsWith('/superadmin')) return isPlatformAdmin;
    if (isPlatformAdmin) return false;

    if (path == '/businesses') return canManageBusinesses;
    if (path == '/billing') return canAccessBilling;
    if (path == '/api-docs') return canAccessApiDocs;
    if (path == '/settings') return canAccessSettings;
    if (path == '/custom-fields') return canManageTeam;
    if (path == '/categories' ||
        path == '/services' ||
        path == '/offers') {
      return canWriteCatalog;
    }
    if (path == '/products') {
      return canWriteCatalog || role == UserRole.employee;
    }
    if (path == '/reports') return canAccessReports;
    if (path == '/orders' ||
        path == '/appointments' ||
        path == '/dashboard') {
      return canManageOrders;
    }

    return true;
  }
}
