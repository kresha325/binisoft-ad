import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/data_table_card.dart';
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
            data: (items) => DataTableCard(
              columns: [l10n.tableName, l10n.tableDescription, l10n.tableActions],
              emptyMessage: l10n.categoriesEmpty,
              minHeight: 280,
              rows: [
                for (final c in items)
                  DataRow(cells: [
                    DataCell(Text(c.name, style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
                    DataCell(Text(c.description ?? '—')),
                    DataCell(
                      TableRowActions(
                        onEdit: () => showCategoryDialog(context, ref, category: c),
                        onDelete: () => deleteCategory(context, ref, c),
                      ),
                    ),
                  ]),
              ],
            ),
          ),
    );
  }
}
