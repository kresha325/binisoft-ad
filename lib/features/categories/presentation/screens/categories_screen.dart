import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/catalog_card_grid.dart';
import '../../../../core/widgets/catalog_entity_card.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../providers/categories_providers.dart';
import '../widgets/add_category_dialog.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesListProvider);

    return PageHeaderActionScope(
      route: '/categories',
      action: ShellAddButton(
        label: l10n.addCategory,
        onPressed: () => showAddCategoryDialog(context, ref),
      ),
      child: categories.when(
            loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
            error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
            data: (items) => CatalogCardGrid(
              emptyMessage: l10n.categoriesEmpty,
              children: [
                for (final c in items)
                  CatalogEntityCard(
                    title: c.name,
                    subtitle: c.description,
                    meta: '/${c.slug}',
                    leading: Icon(Icons.sell_outlined, color: context.appColors.accent, size: 28),
                    trailing: TableRowActions(
                      onEdit: () => showCategoryDialog(context, ref, category: c),
                      onDelete: () => deleteCategory(context, ref, c),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
