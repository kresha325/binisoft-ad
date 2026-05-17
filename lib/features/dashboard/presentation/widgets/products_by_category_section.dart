import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../providers/dashboard_providers.dart';
import 'product_grid_card.dart';

class ProductsByCategorySection extends ConsumerWidget {
  const ProductsByCategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);
    final categoriesAsync = ref.watch(categoriesListProvider);

    final colors = context.appColors;
    final l10n = context.l10n;
    final pad = AppBreakpoints.isMobile(context) ? 16.0 : 20.0;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, 0),
            child: Text(
              l10n.productsByCategoryTitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          productsAsync.when(
            loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.errorGeneric('$e')),
            ),
            data: (products) => categoriesAsync.when(
              loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.errorGeneric('$e')),
              ),
              data: (categories) {
                if (products.isEmpty) {
                  return _emptyState(context);
                }
                final grouped = ref.watch(activeProductsByCategoryProvider);
                return _CategoryGroups(
                  categories: categories,
                  grouped: grouped,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Center(
        child: Text(
          context.l10n.productsByCategoryEmpty,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _CategoryGroups extends StatelessWidget {
  const _CategoryGroups({
    required this.categories,
    required this.grouped,
  });

  final List<Category> categories;
  final Map<String, List<Product>> grouped;

  @override
  Widget build(BuildContext context) {
    final sections = <_Section>[];

    for (final category in categories) {
      final items = grouped[category.id];
      if (items != null && items.isNotEmpty) {
        sections.add(_Section(title: category.name, products: items));
      }
    }

    final uncategorized = grouped[''] ?? [];
    if (uncategorized.isNotEmpty) {
      sections.add(_Section(title: 'Uncategorized', products: uncategorized));
    }

    if (sections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: Text(
            'Products exist but none are assigned to a category yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            _CategorySection(section: sections[i]),
          ],
        ],
      ),
    );
  }
}

class _Section {
  const _Section({required this.title, required this.products});

  final String title;
  final List<Product> products;
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.section});

  final _Section section;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 640
                ? 3
                : constraints.maxWidth > 420
                    ? 2
                    : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  section.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${section.products.length}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final product in section.products)
                  SizedBox(
                    width: crossCount == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - (crossCount - 1) * 12) / crossCount,
                    child: ProductGridCard(product: product),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
