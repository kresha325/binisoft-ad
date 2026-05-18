import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/superadmin_sidebar.dart';
import '../providers/superadmin_providers.dart';

class SuperAdminCardsScreen extends ConsumerWidget {
  const SuperAdminCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);
    final users = ref.watch(superAdminUsersProvider);
    final businesses = ref.watch(superAdminBusinessesProvider);
    final products = ref.watch(superAdminProductsProvider);
    final categories = ref.watch(superAdminCategoriesProvider);
    final offers = ref.watch(superAdminOffersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Platform overview', style: AppTextStyles.pageTitle(context)),
        const SizedBox(height: 6),
        Text(
          'Quick stats across users, businesses, and catalog.',
          style: AppTextStyles.pageSubtitle(context),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 520
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: isMobile ? 2.4 : 2.0,
              children: [
                StatCard(
                  label: 'Users',
                  value: users.valueOrNull?.length.toString() ?? '—',
                  icon: Icons.people_outline_rounded,
                  onTap: () => context.go(SuperAdminNav.consoleRoute),
                ),
                StatCard(
                  label: 'Businesses',
                  value: businesses.valueOrNull?.length.toString() ?? '—',
                  icon: Icons.storefront_outlined,
                  onTap: () => context.go(SuperAdminNav.consoleRoute),
                ),
                StatCard(
                  label: 'Products',
                  value: products.valueOrNull?.length.toString() ?? '—',
                  icon: Icons.inventory_2_outlined,
                  onTap: () => context.go(SuperAdminNav.consoleRoute),
                ),
                StatCard(
                  label: 'Categories',
                  value: categories.valueOrNull?.length.toString() ?? '—',
                  icon: Icons.category_outlined,
                  onTap: () => context.go(SuperAdminNav.consoleRoute),
                ),
                StatCard(
                  label: 'Offers',
                  value: offers.valueOrNull?.length.toString() ?? '—',
                  icon: Icons.local_offer_outlined,
                  onTap: () => context.go(SuperAdminNav.consoleRoute),
                ),
                StatCard(
                  label: 'Shop API',
                  value: 'Keys',
                  icon: Icons.api_outlined,
                  onTap: () => context.go(SuperAdminNav.apiRoute),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _QuickLink(
              icon: Icons.dashboard_customize_outlined,
              label: 'Open console',
              onTap: () => context.go(SuperAdminNav.consoleRoute),
            ),
            _QuickLink(
              icon: Icons.api_outlined,
              label: 'Shop API',
              onTap: () => context.go(SuperAdminNav.apiRoute),
            ),
            _QuickLink(
              icon: Icons.assessment_outlined,
              label: 'Reports',
              onTap: () => context.go(SuperAdminNav.reportsRoute),
            ),
          ],
        ),
        if (users.hasError || businesses.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Some data failed to load. Open console and refresh.',
              style: GoogleFonts.inter(fontSize: 13, color: colors.danger),
            ),
          ),
      ],
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}
