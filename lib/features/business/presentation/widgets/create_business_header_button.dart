import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../providers/business_providers.dart';
import 'create_business_dialog.dart';

/// Shell header action to open the create-store dialog.
class CreateBusinessHeaderButton extends ConsumerWidget {
  const CreateBusinessHeaderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotaAsync = ref.watch(businessQuotaProvider);
    final l10n = context.l10n;

    return quotaAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (quota) => ShellAddButton(
        label: l10n.menuCreateBusiness,
        icon: Icons.add_business_outlined,
        onPressed: () {
          if (!quota.canCreateMore) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.createStoreQuotaSnack(quota.max)),
              ),
            );
            return;
          }
          showCreateBusinessDialog(context, ref);
        },
      ),
    );
  }
}
