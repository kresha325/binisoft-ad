import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/billing/presentation/providers/invoice_providers.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';
import '../layout/app_breakpoints.dart';
import '../router/post_auth_navigation.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'app_icon_button.dart';
import 'app_shell_header.dart';
import 'brand_logo.dart';

class SuperAdminShell extends ConsumerWidget {
  const SuperAdminShell({super.key, required this.child});

  final Widget child;

  static const platformRoute = '/superadmin';
  static const invoicesRoute = '/superadmin/invoices';
  static const reportsRoute = '/superadmin/reports';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final location = GoRouterState.of(context).uri.path;
    final toolbarHeight = AppShellHeader.toolbarHeight(context);

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(toolbarHeight + MediaQuery.paddingOf(context).top),
        child: AppShellHeader(
          leading: const BrandLogo(compact: true, logoOnly: true),
          actions: const [
            NotificationBell(),
            SizedBox(width: 6),
          ],
          trailing: _SuperAdminNavMenu(
            location: location,
            onNavigate: (path) async {
              if (path == 'logout') {
                await signOutAndGoToLogin(context, ref);
              } else {
                context.go(path);
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: AppBreakpoints.screenPadding(context),
        child: Consumer(
          builder: (context, ref, _) {
            ref.watch(billingReportsSyncProvider);
            return SizedBox.expand(child: child);
          },
        ),
      ),
    );
  }
}

class _SuperAdminNavMenu extends StatelessWidget {
  const _SuperAdminNavMenu({
    required this.location,
    required this.onNavigate,
  });

  final String location;
  final Future<void> Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return PopupMenuButton<String>(
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        side: BorderSide(color: colors.cardBorder),
      ),
      elevation: 12,
      constraints: const BoxConstraints(minWidth: 280),
      onSelected: onNavigate,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          height: 52,
          child: Text(
            'Platform admin',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const PopupMenuDivider(),
        _item(
          context,
          value: SuperAdminShell.platformRoute,
          icon: Icons.dashboard_customize_outlined,
          label: 'Platform console',
          active: location == SuperAdminShell.platformRoute,
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          enabled: false,
          height: 40,
          child: Text(
            'Faturat',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        _item(
          context,
          value: '${SuperAdminShell.invoicesRoute}?tab=subscription',
          icon: Icons.workspace_premium_outlined,
          label: 'Abonimet',
          active: location.startsWith(SuperAdminShell.invoicesRoute) &&
              (GoRouterState.of(context).uri.queryParameters['tab'] != 'monthly'),
        ),
        _item(
          context,
          value: '${SuperAdminShell.invoicesRoute}?tab=monthly',
          icon: Icons.calendar_month_outlined,
          label: 'Pagesat mujore',
          active: location.startsWith(SuperAdminShell.invoicesRoute) &&
              GoRouterState.of(context).uri.queryParameters['tab'] == 'monthly',
        ),
        const PopupMenuDivider(),
        _item(
          context,
          value: SuperAdminShell.reportsRoute,
          icon: Icons.assessment_outlined,
          label: 'Raportet',
          active: location.startsWith(SuperAdminShell.reportsRoute),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          height: 46,
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: colors.danger),
              const SizedBox(width: 12),
              Text(
                'Log out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.danger,
                ),
              ),
            ],
          ),
        ),
      ],
      child: AppIconButton(
        icon: Icons.menu_rounded,
        onPressed: null,
      ),
    );
  }

  PopupMenuItem<String> _item(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    required bool active,
  }) {
    final colors = context.appColors;
    final accent = colors.accent;
    return PopupMenuItem(
      value: value,
      height: 46,
      child: Row(
        children: [
          Icon(icon, size: 20, color: active ? accent : colors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? accent : colors.textPrimary,
              ),
            ),
          ),
          if (active) Icon(Icons.chevron_right_rounded, size: 18, color: accent),
        ],
      ),
    );
  }
}
