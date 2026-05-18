import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/permissions_providers.dart';
import '../../features/business/presentation/providers/business_providers.dart';
import '../../features/business/presentation/widgets/business_switcher.dart';
import '../../features/business/presentation/widgets/create_business_dialog.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';
import '../../features/settings/presentation/providers/background_preview_providers.dart';
import '../constants/dashboard_backgrounds.dart';
import '../layout/app_breakpoints.dart';
import '../router/post_auth_navigation.dart';
import '../theme/app_color_scheme.dart';
import 'admin_content.dart';
import 'admin_page_scroll.dart';
import 'admin_sidebar.dart';
import 'app_icon_button.dart';
import 'app_shell_header.dart';
import 'brand_logo.dart';
import 'dashboard_background_layer.dart';
import 'store_slug_handler.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

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

    Future<void> handleNavigate(String path) async {
      if (path == 'logout') {
        await signOutAndGoToLogin(context, ref);
      } else if (path == '__create_business__') {
        await showCreateBusinessDialog(context, ref);
      } else {
        if (context.mounted) context.go(path);
      }
    }

    final sidebar = AdminSidebar(
      location: location,
      onNavigate: handleNavigate,
    );

    final mainContent = Stack(
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
              child: StoreSlugHandler(
                child: AdminPageScroll(child: child),
              ),
            ),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Scaffold(
        backgroundColor: colors.scaffoldBg,
        drawer: Drawer(
          width: AdminSidebar.width,
          child: AdminSidebar(
            location: location,
            onNavigate: handleNavigate,
            onCloseDrawer: () => Navigator.of(context).pop(),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(toolbarHeight + MediaQuery.paddingOf(context).top),
          child: AppShellHeader(
            leading: Builder(
              builder: (ctx) => AppIconButton(
                icon: Icons.menu_rounded,
                tooltip: 'Menu',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            actions: const [
              NotificationBell(),
            ],
            trailing: const BrandLogo(compact: true),
          ),
        ),
        body: mainContent,
      );
    }

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: AdminSidebar.width, child: sidebar),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: toolbarHeight + MediaQuery.paddingOf(context).top,
                  child: AppShellHeader(
                    leading: const BrandLogo(compact: true),
                    actions: [
                      const NotificationBell(),
                      if (ref.watch(businessPermissionsProvider).canManageBusinesses) ...[
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 220),
                          child: BusinessSwitcher(),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(child: mainContent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
