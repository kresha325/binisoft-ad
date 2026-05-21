import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../layout/app_breakpoints.dart';
import '../l10n/l10n_extension.dart';
import '../providers/page_header_action_provider.dart';
import 'mobile_header_action.dart';
import 'page_header.dart';

class ShellPageMeta {
  const ShellPageMeta({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

/// Route titles + business logo header shown on every admin screen.
class ShellPageHeader extends ConsumerWidget {
  const ShellPageHeader({super.key, required this.location, this.uri});

  final String location;
  final Uri? uri;

  static ShellPageMeta? forLocation(
    BuildContext context,
    String location, {
    Uri? uri,
  }) {
    final l10n = context.l10n;
    if (location.startsWith('/orders')) {
      final view = uri?.queryParameters['view'];
      return switch (view) {
        'today' => ShellPageMeta(
            title: l10n.ordersTodayTitle,
            subtitle: l10n.ordersTodaySubtitle,
          ),
        'latest' => ShellPageMeta(
            title: l10n.ordersLatestTitle,
            subtitle: l10n.ordersLatestSubtitle,
          ),
        _ => ShellPageMeta(
            title: l10n.pageOrdersTitle,
            subtitle: l10n.pageOrdersSubtitle,
          ),
      };
    }
    return switch (location) {
      '/dashboard' => ShellPageMeta(
          title: l10n.pageDashboardTitle,
          subtitle: l10n.pageDashboardSubtitle,
        ),
      '/businesses' => ShellPageMeta(
          title: l10n.pageBusinessesTitle,
          subtitle: l10n.pageBusinessesSubtitle,
        ),
      '/products' => ShellPageMeta(
          title: l10n.pageProductsTitle,
          subtitle: l10n.pageProductsSubtitle,
        ),
      '/categories' => ShellPageMeta(
          title: l10n.pageCategoriesTitle,
          subtitle: l10n.pageCategoriesSubtitle,
        ),
      '/services' => ShellPageMeta(
          title: l10n.pageServicesTitle,
          subtitle: l10n.pageServicesSubtitle,
        ),
      '/offers' => ShellPageMeta(
          title: l10n.pageOffersTitle,
          subtitle: l10n.pageOffersSubtitle,
        ),
      '/contests' => ShellPageMeta(
          title: l10n.pageContestsTitle,
          subtitle: l10n.pageContestsSubtitle,
        ),
      '/custom-fields' => ShellPageMeta(
          title: l10n.pageCustomFieldsTitle,
          subtitle: l10n.pageCustomFieldsSubtitle,
        ),
      '/api-docs' => ShellPageMeta(
          title: l10n.pageApiDocsTitle,
          subtitle: l10n.pageApiDocsSubtitle,
        ),
      '/settings' => ShellPageMeta(
          title: l10n.pageSettingsTitle,
          subtitle: l10n.pageSettingsSubtitle,
        ),
      '/billing' => ShellPageMeta(
          title: l10n.pageBillingTitle,
          subtitle: l10n.pageBillingSubtitle,
        ),
      '/reports' => ShellPageMeta(
          title: l10n.pageReportsTitle,
          subtitle: l10n.pageReportsSubtitleLong,
        ),
      '/appointments' => ShellPageMeta(
          title: l10n.pageAppointmentsTitle,
          subtitle: l10n.pageAppointmentsSubtitle,
        ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = forLocation(context, location, uri: uri);
    if (meta == null) return const SizedBox.shrink();

    final entry = ref.watch(pageHeaderActionProvider);
    final rawAction =
        entry != null && entry.route == location ? entry.action : null;
    final isMobile = AppBreakpoints.isMobile(context);
    final action =
        rawAction == null ? null : MobileHeaderAction(child: rawAction);

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      child: PageHeader(
        title: meta.title,
        subtitle: meta.subtitle,
        action: action,
      ),
    );
  }
}
