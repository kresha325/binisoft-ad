import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/shell_add_button.dart';
import '../providers/business_providers.dart';
import 'create_business_dialog.dart';

/// Shell header action to open the create-business dialog.
class CreateBusinessHeaderButton extends ConsumerWidget {
  const CreateBusinessHeaderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotaAsync = ref.watch(businessQuotaProvider);

    return quotaAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (quota) => ShellAddButton(
        label: 'Create new business',
        icon: Icons.add_business_outlined,
        onPressed: () {
          if (!quota.canCreateMore) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Business limit reached (${quota.label}). '
                  'Upgrade your plan in Settings to add more.',
                ),
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
