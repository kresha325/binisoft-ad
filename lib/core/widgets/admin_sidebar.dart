import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/presentation/providers/permissions_providers.dart';
import '../../features/business/presentation/providers/business_providers.dart';
import 'package:business_dashboard/l10n/app_localizations.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'app_language_menu_row.dart';

/// Permanent left navigation (desktop) or drawer content (mobile).
class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({
    super.key,
    required this.location,
    required this.onNavigate,
    this.onCloseDrawer,
  });

  final String location;
  final Future<void> Function(String path) onNavigate;
  final VoidCallback? onCloseDrawer;

  static const double width = 252;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final perms = ref.watch(businessPermissionsProvider);
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final canCreateMore = ref.watch(businessQuotaProvider).valueOrNull?.canCreateMore ?? true;

    final navRoutes = AdminShellNav.routes(l10n)
        .where((r) => perms.canAccessRoute(r.path))
        .toList();

    final sidebarBg = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.35),
      colors.scaffoldBg,
    );

    Future<void> go(String path) async {
      onCloseDrawer?.call();
      await onNavigate(path);
    }

    return Material(
      color: sidebarBg,
      child: SafeArea(
        top: false,
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (business != null && onCloseDrawer == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Text(
                  business.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  12,
                  business != null && onCloseDrawer == null ? 0 : 16,
                  12,
                  0,
                ),
                children: [
                  for (final item in navRoutes)
                    _NavTile(
                      icon: item.icon,
                      label: item.label,
                      active: location == item.path,
                      onTap: () => go(item.path),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppLanguageMenuRow(),
                  if (canCreateMore && perms.canManageBusinesses) ...[
                    const SizedBox(height: 8),
                    _NavTile(
                      icon: Icons.add_business_outlined,
                      label: l10n.menuCreateBusiness,
                      active: false,
                      onTap: () => go('__create_business__'),
                    ),
                  ],
                  const SizedBox(height: 4),
                  _NavTile(
                    icon: Icons.logout_rounded,
                    label: l10n.menuLogOut,
                    active: false,
                    danger: true,
                    onTap: () => go('logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminShellNav {
  AdminShellNav._();

  static List<AdminNavItem> routes(AppLocalizations l10n) => [
        AdminNavItem('/dashboard', l10n.navDashboard, Icons.grid_view_rounded),
        AdminNavItem('/products', l10n.navProducts, Icons.inventory_2_outlined),
        AdminNavItem('/categories', l10n.navCategories, Icons.sell_outlined),
        AdminNavItem('/services', l10n.navServices, Icons.design_services_outlined),
        AdminNavItem('/offers', l10n.navOffers, Icons.local_offer_outlined),
        AdminNavItem('/contests', l10n.navContests, Icons.emoji_events_outlined),
        AdminNavItem('/orders', l10n.navOrders, Icons.shopping_bag_outlined),
        AdminNavItem('/appointments', l10n.navAppointments, Icons.event_outlined),
        AdminNavItem('/reports', l10n.navReports, Icons.analytics_outlined),
        AdminNavItem('/businesses', l10n.navBusinesses, Icons.business_outlined),
        AdminNavItem('/custom-fields', l10n.navCustomFields, Icons.description_outlined),
        AdminNavItem('/api-docs', l10n.navApiDocs, Icons.code_rounded),
        AdminNavItem('/settings', l10n.navSettings, Icons.settings_outlined),
        AdminNavItem('/billing', l10n.navBilling, Icons.receipt_long_outlined),
      ];
}

class AdminNavItem {
  const AdminNavItem(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = danger ? colors.danger : colors.accent;
    final fg = active ? Colors.white : (danger ? colors.danger : colors.textPrimary);
    final iconColor = active ? Colors.white : (danger ? colors.danger : colors.textMuted);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
