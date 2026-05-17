import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/attribute_type_labels.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../providers/attributes_providers.dart';
import '../widgets/add_field_dialog.dart';
import '../widgets/default_fields_section.dart';

class CustomFieldsScreen extends ConsumerWidget {
  const CustomFieldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final attrs = ref.watch(attributesListProvider);

    return PageHeaderActionScope(
      route: '/custom-fields',
      action: ShellAddButton(
        label: l10n.addField,
        onPressed: () => showAddFieldDialog(context, ref),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DefaultFieldsSection(),
        const SizedBox(height: 20),
        Text(
          l10n.customFieldsAll,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: attrs.when(
            loading: () => const LoadingOverlay(),
            error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
            data: (items) => DataTableCard(
              columns: [
                l10n.tableLabel,
                l10n.tableKey,
                l10n.tableType,
                l10n.tableStatus,
                l10n.tableRequired,
              ],
              emptyMessage: l10n.customFieldsEmpty,
              minHeight: 280,
              rows: [
                for (final a in items)
                  DataRow(cells: [
                    DataCell(Text(a.name, style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
                    DataCell(Text(a.key, style: const TextStyle(fontFamily: 'monospace'))),
                    DataCell(Text(a.type.label)),
                    DataCell(Text(a.active ? l10n.statusActive : l10n.statusInactive)),
                    DataCell(Text(a.required ? l10n.yes : l10n.no)),
                  ]),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}
