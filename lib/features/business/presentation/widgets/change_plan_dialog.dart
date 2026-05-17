import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_form_dialog.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../billing/services/billing_service.dart';
import '../../../auth/presentation/widgets/plan_selector.dart';
import '../../../products/presentation/providers/products_providers.dart';

Future<void> showChangePlanDialog(BuildContext context, WidgetRef ref) async {
  final user = ref.read(authStateProvider).valueOrNull;
  if (user == null) return;

  var selected = BusinessPlan.fromMaxProducts(user.maxProducts);
  final productQuota = ref.read(productQuotaProvider);

  final ok = await showAppFormDialog<bool>(
    context: context,
    title: 'Change plan',
    saveLabel: 'Update plan',
    maxWidth: 560,
    child: StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Current catalog: ${productQuota.label}. '
              'Downgrading requires fewer products than the new limit.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          PlanSelector(
            compact: true,
            selected: selected,
            onSelected: (p) => setState(() => selected = p),
          ),
        ],
      ),
    ),
    onSave: () async {
      if (selected.maxProducts == user.maxProducts) return true;
      try {
        await ref.read(authControllerProvider.notifier).updatePlan(selected);
        ref.invalidate(productQuotaProvider);
        final updated = ref.read(authStateProvider).valueOrNull;
        if (updated != null) {
          await ref.read(billingServiceProvider).recordPlanChange(
                userId: updated.id,
                userEmail: updated.email,
                plan: selected,
              );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
          );
        }
        return false;
      }
    },
  );

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Plan updated to ${selected.title} · up to ${selected.maxProducts} products · '
          '${selected.pricingHeadline}',
        ),
      ),
    );
  }
}
