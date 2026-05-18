import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/billing/presentation/providers/invoice_providers.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';
import '../layout/app_breakpoints.dart';
import '../router/post_auth_navigation.dart';
import '../theme/app_color_scheme.dart';
import 'admin_content.dart';
import 'app_icon_button.dart';
import 'app_shell_header.dart';
import 'brand_logo.dart';
import 'superadmin_sidebar.dart';

class SuperAdminShell extends ConsumerWidget {
  const SuperAdminShell({super.key, required this.child});

  final Widget child;

  static const platformRoute = SuperAdminNav.consoleRoute;
  static const apiRoute = SuperAdminNav.apiRoute;
  static const cardsRoute = SuperAdminNav.cardsRoute;
  static const invoicesRoute = '/superadmin/invoices';
  static const reportsRoute = SuperAdminNav.reportsRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final routerState = GoRouterState.of(context);
    final location = routerState.uri.path;
    final uri = routerState.uri;
    final isMobile = AppBreakpoints.isMobile(context);
    final toolbarHeight = AppShellHeader.toolbarHeight(context);

    Future<void> handleNavigate(String path) async {
      if (path == 'logout') {
        await signOutAndGoToLogin(context, ref);
      } else {
        if (context.mounted) context.go(path);
      }
    }

    final sidebar = SuperAdminSidebar(
      location: location,
      uri: uri,
      onNavigate: handleNavigate,
    );

    final mainContent = Padding(
      padding: isMobile
          ? AppBreakpoints.screenPadding(context)
          : const EdgeInsets.fromLTRB(20, 16, 24, 24),
      child: AdminContent(child: child),
    );

    if (isMobile) {
      return Scaffold(
        backgroundColor: colors.scaffoldBg,
        drawer: Drawer(
          width: SuperAdminSidebar.width,
          child: SuperAdminSidebar(
            location: location,
            uri: uri,
            onNavigate: handleNavigate,
            onCloseDrawer: () => Navigator.of(context).pop(),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(toolbarHeight + MediaQuery.paddingOf(context).top),
          child: AppShellHeader.wrapBar(
            context,
            child: SizedBox(
              height: toolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const BrandLogo(compact: true),
                    const Spacer(),
                    const NotificationBell(),
                    const SizedBox(width: 4),
                    Builder(
                      builder: (ctx) => AppIconButton(
                        icon: Icons.menu_rounded,
                        tooltip: 'Menu',
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Consumer(
          builder: (context, ref, _) {
            ref.watch(billingReportsSyncProvider);
            return mainContent;
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Consumer(
        builder: (context, ref, _) {
          ref.watch(billingReportsSyncProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: toolbarHeight + MediaQuery.paddingOf(context).top,
                child: const AppShellHeader(
                  leading: BrandLogo(compact: true),
                  actions: [
                    NotificationBell(),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: SuperAdminSidebar.width, child: sidebar),
                    Expanded(child: mainContent),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
