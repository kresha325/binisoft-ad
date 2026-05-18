import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'brand_logo.dart';

class SuperAdminNav {
  const SuperAdminNav({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;

  static const consoleRoute = '/superadmin';
  static const apiRoute = '/superadmin/api';
  static const cardsRoute = '/superadmin/cards';
  static const invoicesSubscription = '/superadmin/invoices?tab=subscription';
  static const invoicesMonthly = '/superadmin/invoices?tab=monthly';
  static const reportsRoute = '/superadmin/reports';

  static List<SuperAdminNav> mainItems() => const [
        SuperAdminNav(
          path: consoleRoute,
          icon: Icons.dashboard_customize_outlined,
          label: 'Platform console',
        ),
        SuperAdminNav(
          path: apiRoute,
          icon: Icons.api_outlined,
          label: 'Shop API',
        ),
        SuperAdminNav(
          path: cardsRoute,
          icon: Icons.grid_view_rounded,
          label: 'Cards',
        ),
      ];

  static bool isActive(String location, Uri uri, String path) {
    if (path == consoleRoute) return location == consoleRoute;
    return location.startsWith(path.split('?').first);
  }
}

class SuperAdminSidebar extends StatelessWidget {
  const SuperAdminSidebar({
    super.key,
    required this.location,
    required this.uri,
    required this.onNavigate,
    this.onCloseDrawer,
  });

  final String location;
  final Uri uri;
  final Future<void> Function(String path) onNavigate;
  final VoidCallback? onCloseDrawer;

  static const double width = 252;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sidebarBg = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.35),
      colors.scaffoldBg,
    );

    Future<void> go(String path) async {
      onCloseDrawer?.call();
      await onNavigate(path);
    }

    final invoicesActive = location.startsWith('/superadmin/invoices');
    final monthlyActive = invoicesActive && uri.queryParameters['tab'] == 'monthly';
    final subscriptionActive = invoicesActive && !monthlyActive;

    return Material(
      color: sidebarBg,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: colors.accent, size: 22),
                  const SizedBox(width: 10),
                  const Expanded(child: BrandLogo(compact: true)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
              child: Text(
                'Platform admin',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final item in SuperAdminNav.mainItems())
                    _NavTile(
                      icon: item.icon,
                      label: item.label,
                      active: SuperAdminNav.isActive(location, uri, item.path),
                      onTap: () => go(item.path),
                    ),
                  const SizedBox(height: 8),
                  _sectionLabel(context, 'Faturat'),
                  _NavTile(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Abonimet',
                    active: subscriptionActive,
                    onTap: () => go(SuperAdminNav.invoicesSubscription),
                  ),
                  _NavTile(
                    icon: Icons.calendar_month_outlined,
                    label: 'Pagesat mujore',
                    active: monthlyActive,
                    onTap: () => go(SuperAdminNav.invoicesMonthly),
                  ),
                  const SizedBox(height: 8),
                  _NavTile(
                    icon: Icons.assessment_outlined,
                    label: 'Raportet',
                    active: location.startsWith(SuperAdminNav.reportsRoute),
                    onTap: () => go(SuperAdminNav.reportsRoute),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: _NavTile(
                icon: Icons.logout_rounded,
                label: 'Log out',
                active: false,
                danger: true,
                onTap: () => go('logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: context.appColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active ? colors.accent.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: active ? accent : (danger ? colors.danger : colors.textMuted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: active ? accent : (danger ? colors.danger : colors.textPrimary),
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
