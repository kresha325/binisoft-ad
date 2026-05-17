import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/image_url_upload_row.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/constants/business_plans.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../business/presentation/widgets/change_plan_dialog.dart';
import '../../../notifications/presentation/widgets/email_notifications_section.dart';
import '../widgets/api_languages_section.dart';
import '../widgets/appearance_section.dart';
import '../widgets/background_picker_section.dart';
import '../../../../core/constants/dashboard_backgrounds.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _logoUrl = TextEditingController();
  final _orderPhone = TextEditingController();
  bool _initialized = false;
  bool _saving = false;
  PlatformFile? _logoFile;
  String? _backgroundPresetId;
  String? _backgroundImageUrl;
  double _backgroundOverlayOpacity = DashboardBackgrounds.defaultOverlayOpacity;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _logoUrl.dispose();
    _orderPhone.dispose();
    super.dispose();
  }

  void _initFromBusiness() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    if (business == null || _initialized) return;
    _name.text = business.name;
    _description.text = business.description ?? '';
    _logoUrl.text = business.logoUrl ?? '';
    _orderPhone.text = business.orderPhone ?? '';
    _backgroundPresetId = business.backgroundPresetId;
    _backgroundImageUrl = business.backgroundImageUrl;
    _backgroundOverlayOpacity = DashboardBackgrounds.resolveOverlayOpacity(
      business.backgroundOverlayOpacity,
    );
    if (_backgroundPresetId == null || _backgroundPresetId!.isEmpty) {
      _backgroundPresetId = DashboardBackgrounds.noneId;
    }
    _initialized = true;
  }

  Future<void> _save() async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    setState(() => _saving = true);
    try {
      var logoUrl = _logoUrl.text.trim();

      if (_logoFile != null) {
        logoUrl = await ref.read(mediaUploadServiceProvider).uploadBusinessLogo(
              businessId: businessId,
              file: _logoFile!,
            );
      } else if (logoUrl.isNotEmpty && logoUrl.contains('firebasestorage')) {
        logoUrl = await ref.read(mediaUploadServiceProvider).resolveImageUrl(logoUrl);
      }

      final customBg = _backgroundImageUrl?.trim() ?? '';
      final hasCustomBg = customBg.isNotEmpty;
      final presetId = !hasCustomBg &&
              _backgroundPresetId != null &&
              _backgroundPresetId != DashboardBackgrounds.noneId
          ? _backgroundPresetId
          : null;

      await ref.read(businessRepositoryProvider).updateProfile(
            businessId: businessId,
            name: _name.text.trim(),
            description: _description.text.trim(),
            logoUrl: logoUrl,
            backgroundPresetId: presetId,
            backgroundImageUrl: hasCustomBg ? customBg : null,
            backgroundOverlayOpacity: DashboardBackgrounds.hasActiveBackground(
              presetId: presetId,
              customImageUrl: hasCustomBg ? customBg : null,
            )
                ? _backgroundOverlayOpacity
                : null,
            orderPhone: _orderPhone.text.trim(),
          );
      ref.invalidate(currentBusinessProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.changesSaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessAsync = ref.watch(currentBusinessProvider);

    return businessAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => Center(child: Text(context.l10n.errorGeneric('$e'))),
      data: (business) {
        final l10n = context.l10n;
        if (business != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _initFromBusiness());
        }

        return SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppearanceSection(),
            const SizedBox(height: 16),
            const ApiLanguagesSection(),
            const SizedBox(height: 16),
            const EmailNotificationsSection(),
            const SizedBox(height: 16),
            _PlanCard(),
            const SizedBox(height: 16),
            BackgroundPickerSection(
              initialPresetId: _backgroundPresetId,
              initialCustomUrl: _backgroundImageUrl,
              initialOverlayOpacity: _backgroundOverlayOpacity,
              onChanged: (presetId, customUrl, overlayOpacity) {
                setState(() {
                  _backgroundPresetId = presetId ?? DashboardBackgrounds.noneId;
                  _backgroundImageUrl = customUrl;
                  _backgroundOverlayOpacity = overlayOpacity;
                });
              },
            ),
            const SizedBox(height: 16),
            AppSectionCard(
              title: l10n.settingsActiveBusinessTitle,
              subtitle: l10n.settingsActiveBusinessSubtitle,
              icon: Icons.storefront_outlined,
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(label: l10n.settingsBusinessName, controller: _name),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsDescription,
                    controller: _description,
                    hint: l10n.settingsDescriptionHint,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ImageUrlUploadRow(
                    label: l10n.settingsLogoUrl,
                    urlController: _logoUrl,
                    onFilePicked: (f) => setState(() => _logoFile = f),
                    fileName: _logoFile?.name,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsOrderPhone,
                    controller: _orderPhone,
                    hint: '+38344416502',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsOrderPhoneNote,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.saveChanges),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}

class _PlanCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final productQuota = ref.watch(productQuotaProvider);
    if (user == null) return const SizedBox.shrink();

    final plan = BusinessPlan.fromMaxProducts(user.maxProducts);

    final colors = context.appColors;
    final l10n = context.l10n;
    return AppSectionCard(
      title: l10n.subscriptionPlanTitle,
      subtitle: plan.pricingDetail,
      icon: Icons.workspace_premium_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${plan.title} · ${plan.pricingHeadline}',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.accent,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            plan.summary,
            style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            productQuota.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => showChangePlanDialog(context, ref),
            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            label: Text(l10n.changePlan),
          ),
          const SizedBox(height: 12),
          Text(
            productQuota.canCreateMore
                ? 'You can add up to ${plan.maxProducts} products on the ${plan.title} plan '
                    '(${plan.pricingHeadline}).'
                : 'Product limit reached (${productQuota.label}). Upgrade your plan to add more products.',
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
          ),
        ],
      ),
    );
  }
}
