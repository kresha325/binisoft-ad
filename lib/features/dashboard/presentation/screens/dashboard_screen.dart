import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/widgets/create_business_prompt_card.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../orders/presentation/widgets/recent_orders_section.dart';
import '../../../orders/presentation/widgets/top_products_section.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/products_by_category_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final orderStats = ref.watch(orderDashboardStatsProvider);
    final productsLoading = ref.watch(productsListProvider).isLoading;
    final categoriesLoading = ref.watch(categoriesListProvider).isLoading;
    final ordersLoading = ref.watch(ordersListProvider).isLoading;
    final statsLoading = productsLoading || categoriesLoading || ordersLoading;
    final hasBusiness = ref.watch(hasActiveBusinessProvider);
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hasBusiness) const CreateBusinessPromptCard(),
        if (statsLoading)
          const SizedBox(height: 120, child: LoadingOverlay())
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = AppBreakpoints.isMobile(context);
              final count = constraints.maxWidth > AppBreakpoints.tablet
                  ? 3
                  : constraints.maxWidth > 560
                      ? 2
                      : 1;
              final cards = [
                StatCard(
                  label: l10n.dashboardOrdersToday,
                  value: '${orderStats.todayCount}',
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => context.go('/orders?view=today'),
                ),
                StatCard(
                  label: l10n.dashboardPendingOrders,
                  value: '${orderStats.newCount}',
                  icon: Icons.fiber_new_rounded,
                  onTap: () => context.go('/orders?view=latest'),
                ),
                StatCard(
                  label: l10n.dashboardSalesWeek,
                  value: '€${orderStats.weekRevenueEur.toStringAsFixed(0)}',
                  icon: Icons.trending_up_rounded,
                  onTap: () => context.go('/reports'),
                ),
                StatCard(
                  label: l10n.dashboardTotalProducts,
                  value: '${stats.totalProducts}',
                  icon: Icons.inventory_2_outlined,
                  onTap: () => context.go('/products'),
                ),
                StatCard(
                  label: l10n.dashboardActiveProducts,
                  value: '${stats.activeProducts}',
                  icon: Icons.check_circle_outline,
                  onTap: () => context.go('/products?status=active'),
                ),
                StatCard(
                  label: l10n.dashboardCategories,
                  value: '${stats.totalCategories}',
                  icon: Icons.sell_outlined,
                  onTap: () => context.go('/categories'),
                ),
              ];

              if (isMobile) {
                return Column(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 8),
                      cards[i],
                    ],
                  ],
                );
              }

              final aspectRatio = switch (count) {
                3 => 1.75,
                2 => 2.0,
                _ => 1.45,
              };
              return GridView.count(
                crossAxisCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: aspectRatio,
                children: cards,
              );
            },
          ),
        if (hasBusiness) ...[
          const SizedBox(height: 20),
          const TopProductsSection(),
          const SizedBox(height: 16),
          const RecentOrdersSection(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.go('/orders'),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: Text(l10n.viewAllOrders),
            ),
          ),
          const SizedBox(height: 24),
          const ProductsByCategorySection(),
        ],
      ],
      ),
    );
  }
}
