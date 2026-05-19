import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/catalog_card_grid.dart';
import '../../../../core/widgets/catalog_entity_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../providers/services_providers.dart';
import '../widgets/add_service_dialog.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final services = ref.watch(servicesListProvider);

    return PageHeaderActionScope(
      route: '/services',
      action: ShellAddButton(
        label: l10n.serviceAddTitle,
        onPressed: () => showAddServiceDialog(context, ref),
      ),
      child: services.when(
        loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
        data: (items) => CatalogCardGrid(
          emptyMessage: l10n.servicesEmpty,
          children: [
            for (final s in items)
              CatalogEntityCard(
                title: s.name,
                subtitle: s.description,
                meta: [
                  if (s.durationLabel != null) s.durationLabel!,
                  if (s.priceLabel != null) s.priceLabel!,
                  '/${s.slug}',
                ].join(' · '),
                leading: Icon(
                  Icons.design_services_outlined,
                  color: colors.accent,
                  size: 28,
                ),
                chips: [
                  StatusChip(
                    label: s.active ? l10n.statusActive : l10n.statusInactive,
                    tone: s.active
                        ? StatusChipTone.success
                        : StatusChipTone.neutral,
                  ),
                ],
                trailing: TableRowActions(
                  onEdit: () => showServiceDialog(context, ref, service: s),
                  onDelete: () => deleteService(context, ref, s),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
