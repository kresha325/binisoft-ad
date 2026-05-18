import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/constants/payment_config.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_form_dialog.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/widgets/registration_payment_modal.dart';
import '../../../billing/presentation/providers/invoice_providers.dart';
import '../../../billing/services/billing_service.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/presentation/providers/attributes_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../providers/business_providers.dart';

Future<void> showCreateBusinessDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final quota = await ref.read(businessQuotaProvider.future);
  if (!quota.canCreateMore) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.createStoreQuotaSnack(quota.max)),
          backgroundColor: Colors.orange,
        ),
      );
    }
    return;
  }
  if (!context.mounted) return;

  final user = ref.read(authStateProvider).valueOrNull;
  final plan = user != null
      ? BusinessPlan.fromMaxProducts(user.maxProducts)
      : BusinessPlan.defaultPlan;

  final nameController = TextEditingController();
  final slugController = TextEditingController();
  var slugManual = false;

  final formOk = await showAppFormDialog<bool>(
    context: context,
    title: l10n.createStoreDialogTitle(quota.owned + 1, quota.max),
    saveLabel: l10n.createStoreContinuePayment,
    child: StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.createStoreDialogIntro(plan.registrationPriceLabel),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.appColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.businessNameLabel,
            controller: nameController,
            onChanged: (v) {
              if (!slugManual) slugController.text = slugify(v);
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.businessSlugLabel,
            controller: slugController,
            helperText: l10n.businessSlugHelper,
            onChanged: (_) => slugManual = true,
          ),
        ],
      ),
    ),
    onSave: () async {
      if (nameController.text.trim().isEmpty) return false;
      if (slugify(slugController.text.trim()).isEmpty) return false;
      return true;
    },
  );

  if (formOk != true || !context.mounted) {
    nameController.dispose();
    slugController.dispose();
    return;
  }

  final businessName = nameController.text.trim();
  final businessSlug = slugify(slugController.text.trim());
  nameController.dispose();
  slugController.dispose();

  if (user == null) return;

  final paid = await showNewBusinessPaymentModal(
    context,
    plan: plan,
    businessName: businessName,
  );
  if (!paid || !context.mounted) return;

  try {
    await ref.read(authControllerProvider.notifier).createBusiness(
          name: businessName,
          slug: businessSlug,
        );

    try {
      await ref.read(billingServiceProvider).recordNewBusinessPayment(
            userId: user.id,
            userEmail: user.email,
            plan: plan,
            businessName: businessName,
            amountEur: plan.registrationEuro,
            paymentMethod: PaymentConfig.demoMode ? 'demo' : 'card',
          );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.businessCreatedInvoiceFailed)),
        );
      }
    }

    ref.invalidate(ownedBusinessesProvider);
    ref.invalidate(businessQuotaProvider);
    ref.invalidate(currentBusinessProvider);
    ref.invalidate(authStateProvider);
    ref.invalidate(productsListProvider);
    ref.invalidate(categoriesListProvider);
    ref.invalidate(attributesListProvider);
    ref.invalidate(myInvoicesProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.createStoreSuccess)),
    );
    context.go('/dashboard');
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
      );
    }
  }
}
