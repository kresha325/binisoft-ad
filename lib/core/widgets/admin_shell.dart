import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/business/presentation/providers/business_providers.dart';
import '../../features/settings/presentation/providers/background_preview_providers.dart';
import '../../features/business/presentation/widgets/business_switcher.dart';
import '../../features/business/presentation/widgets/create_business_dialog.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';
import 'package:business_dashboard/l10n/app_localizations.dart';

import '../constants/dashboard_backgrounds.dart';
import '../l10n/l10n_extension.dart';
import 'app_language_menu_row.dart';
import '../layout/app_breakpoints.dart';
import '../router/post_auth_navigation.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'admin_content.dart';
import 'admin_page_scroll.dart';
import 'app_icon_button.dart';
import 'app_shell_header.dart';
import 'brand_logo.dart';
import 'dashboard_background_layer.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  static List<(String, String, IconData)> routes(AppLocalizations l10n) => [
        ('/dashboard', l10n.navDashboard, Icons.grid_view_rounded),
        ('/orders', l10n.navOrders, Icons.shopping_bag_outlined),
        ('/reports', l10n.navReports, Icons.analytics_outlined),
        ('/businesses', l10n.navBusinesses, Icons.business_outlined),
        ('/products', l10n.navProducts, Icons.inventory_2_outlined),
        ('/categories', l10n.navCategories, Icons.sell_outlined),
        ('/offers', l10n.navOffers, Icons.local_offer_outlined),
        ('/custom-fields', l10n.navCustomFields, Icons.description_outlined),
        ('/api-docs', l10n.navApiDocs, Icons.code_rounded),
        ('/settings', l10n.navSettings, Icons.settings_outlined),
        ('/billing', l10n.navBilling, Icons.receipt_long_outlined),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerUri = GoRouterState.of(context).uri;
    final location = routerUri.path;
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);
    final toolbarHeight = AppShellHeader.toolbarHeight(context);
    final customBg = business?.backgroundImageUrl;
    final presetBg = business?.backgroundPresetId;
    final previewOpacity = ref.watch(backgroundOverlayPreviewProvider);
    final overlayOpacity = previewOpacity ??
        DashboardBackgrounds.resolveOverlayOpacity(business?.backgroundOverlayOpacity);

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(toolbarHeight + MediaQuery.paddingOf(context).top),
        child: AppShellHeader(
          leading: const BrandLogo(compact: true),
          actions: [
            const NotificationBell(),
            if (!isMobile) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: BusinessSwitcher(),
                  ),
                ),
              ),
            ],
          ],
          trailing: _NavMenu(
            location: location,
            onNavigate: (path) async {
              if (path == 'logout') {
                await signOutAndGoToLogin(context, ref);
              } else if (path == '__create_business__') {
                await showCreateBusinessDialog(context, ref);
              } else {
                context.go(path);
              }
            },
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          DashboardBackgroundLayer(
            presetId: presetBg,
            customImageUrl: customBg,
            overlayOpacity: overlayOpacity,
          ),
          Positioned.fill(
            child: Padding(
              padding: AppBreakpoints.screenPadding(context),
              child: AdminContent(
                child: AdminPageScroll(child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavMenu extends ConsumerWidget {
  const _NavMenu({
    required this.location,
    required this.onNavigate,
  });

  final String location;
  final Future<void> Function(String path) onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final businessName = business?.name ?? 'Business';
    final canCreateMore = ref.watch(businessQuotaProvider).valueOrNull?.canCreateMore ?? true;
    final navRoutes = AdminShell.routes(l10n);

    return PopupMenuButton<String>(
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        side: BorderSide(color: colors.cardBorder),
      ),
      elevation: 12,
      shadowColor: Colors.black26,
      constraints: const BoxConstraints(minWidth: 272),
      onSelected: onNavigate,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          height: 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.menuSignedInAs,
                style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, letterSpacing: 0.3),
              ),
              const SizedBox(height: 2),
              Text(
                businessName,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: AppLanguageMenuRow(),
        ),
        const PopupMenuDivider(height: 1),
        for (final (path, label, icon) in navRoutes)
          PopupMenuItem(
            value: path,
            height: 46,
            child: _MenuRow(
              icon: icon,
              label: label,
              active: location == path,
            ),
          ),
        const PopupMenuDivider(height: 1),
        if (canCreateMore)
          PopupMenuItem(
            value: '__create_business__',
            height: 46,
            child: Row(
              children: [
                Icon(Icons.add_business_outlined, size: 20, color: colors.accent),
                const SizedBox(width: 12),
                Text(
                  l10n.menuCreateBusiness,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'logout',
          height: 46,
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: colors.danger),
              const SizedBox(width: 12),
              Text(
                l10n.menuLogOut,
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
        tooltip: 'Menu',
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;
    final color = active ? accent : colors.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 20, color: active ? accent : colors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ),
        if (active) Icon(Icons.chevron_right_rounded, size: 18, color: accent),
      ],
    );
  }
}
