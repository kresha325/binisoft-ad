import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/catalog_card_grid.dart';
import '../../../../core/widgets/catalog_entity_card.dart';
import '../../../../core/widgets/storage_network_image.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../../../auth/presentation/providers/permissions_providers.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../domain/entities/product.dart';
import '../providers/products_providers.dart';
import '../widgets/add_product_sheet.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _search = '';
  String? _categoryFilter;
  ProductStatus? _statusFilter;
  String? _lastRouteStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final status = GoRouterState.of(context).uri.queryParameters['status'];
    if (status == _lastRouteStatus) return;
    _lastRouteStatus = status;
    final next = switch (status) {
      'active' => ProductStatus.active,
      'draft' => ProductStatus.draft,
      'archived' => ProductStatus.archived,
      _ => null,
    };
    if (next != _statusFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _statusFilter = next);
      });
    }
  }

  void _setStatusFilter(ProductStatus? status) {
    setState(() => _statusFilter = status);
    final path = switch (status) {
      ProductStatus.active => '/products?status=active',
      ProductStatus.draft => '/products?status=draft',
      ProductStatus.archived => '/products?status=archived',
      null => '/products',
    };
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final productsAsync = ref.watch(productsListProvider);
    final categoriesAsync = ref.watch(categoriesListProvider);
    final productQuota = ref.watch(productQuotaProvider);
    final canWrite = ref.watch(businessPermissionsProvider).canWriteCatalog;

    return PageHeaderActionScope(
      route: '/products',
      action: canWrite
          ? ShellAddButton(
        label: l10n.addProduct,
        onPressed: productQuota.canCreateMore
            ? () {
                final cats = categoriesAsync.valueOrNull ?? [];
                showAddProductSheet(context, ref, categories: cats);
              }
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product limit reached (${productQuota.label}). '
                      'Upgrade plan in Settings.',
                    ),
                  ),
                );
              },
      )
          : const SizedBox.shrink(),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (productQuota.max > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              productQuota.label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ),
        SearchToolbar(
          searchHint: l10n.searchProducts,
          onSearchChanged: (v) => setState(() => _search = v.toLowerCase()),
          filter: categoriesAsync.when(
            data: (cats) => FilterDropdown(
              value: _categoryFilter,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.filterAllCategories)),
                for (final c in cats)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _categoryFilter = v),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _statusChip(l10n.filterAll, _statusFilter == null, () => _setStatusFilter(null)),
            _statusChip(
              l10n.productStatusActive,
              _statusFilter == ProductStatus.active,
              () => _setStatusFilter(ProductStatus.active),
            ),
            _statusChip(
              l10n.productStatusDraft,
              _statusFilter == ProductStatus.draft,
              () => _setStatusFilter(ProductStatus.draft),
            ),
            _statusChip(
              l10n.productStatusArchived,
              _statusFilter == ProductStatus.archived,
              () => _setStatusFilter(ProductStatus.archived),
            ),
          ],
        ),
        SizedBox(height: AppBreakpoints.isMobile(context) ? 12 : 16),
        productsAsync.when(
            loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
            error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
            data: (items) {
              var filtered = items;
              if (_search.isNotEmpty) {
                filtered = filtered
                    .where((p) =>
                        p.name.toLowerCase().contains(_search) ||
                        p.slug.contains(_search))
                    .toList();
              }
              if (_categoryFilter != null) {
                filtered = filtered
                    .where((p) => p.categoryIds.contains(_categoryFilter))
                    .toList();
              }
              if (_statusFilter != null) {
                filtered =
                    filtered.where((p) => p.status == _statusFilter).toList();
              }

              final categoryMap = {
                for (final c in categoriesAsync.valueOrNull ?? []) c.id: c.name,
              };

              final colors = context.appColors;

              return CatalogCardGrid(
                emptyMessage: l10n.productsEmpty,
                children: [
                  for (final p in filtered)
                    CatalogEntityCard(
                      title: p.name,
                      subtitle: p.categoryIds.isEmpty
                          ? null
                          : p.categoryIds.map((id) => categoryMap[id] ?? '—').join(', '),
                      meta: p.basePrice != null
                          ? '€${p.basePrice!.toStringAsFixed(2)} · /${p.slug}'
                          : '/${p.slug}',
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: p.imageUrls.isNotEmpty
                            ? StorageNetworkImage(
                                url: p.imageUrls.first,
                                width: 56,
                                height: 56,
                              )
                            : Container(
                                width: 56,
                                height: 56,
                                color: colors.surfaceElevated,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 24,
                                  color: colors.textMuted,
                                ),
                              ),
                      ),
                      chips: [_productStatusChip(p.status)],
                      trailing: TableRowActions(
                        onEdit: () => showProductSheet(
                          context,
                          ref,
                          categories: categoriesAsync.valueOrNull ?? [],
                          product: p,
                        ),
                        onDelete: () => deleteProduct(context, ref, p),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
      ),
    );
  }

  Widget _statusChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}

Widget _productStatusChip(ProductStatus status) {
  final (label, tone) = switch (status) {
    ProductStatus.active => ('Active', StatusChipTone.success),
    ProductStatus.draft => ('Draft', StatusChipTone.neutral),
    ProductStatus.archived => ('Archived', StatusChipTone.warning),
  };
  return StatusChip(label: label, tone: tone);
}
