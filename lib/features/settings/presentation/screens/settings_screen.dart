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
import '../../../business/domain/business_address.dart';
import '../../../business/domain/entities/business_type.dart';
import '../../../business/domain/entities/website_plan.dart';
import '../../../business/presentation/widgets/business_type_dropdown_field.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../../core/utils/google_maps_url.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../auth/presentation/providers/permissions_providers.dart';
import '../../../business/presentation/widgets/change_plan_dialog.dart';
import '../../../team/presentation/widgets/team_section.dart';
import '../widgets/api_languages_section.dart';
import '../widgets/appearance_section.dart';
import '../widgets/background_picker_section.dart';
import '../widgets/business_website_section.dart';
import '../widgets/business_site_editor_section.dart';
import '../widgets/shop_preview_dialog.dart';
import '../../domain/shop_preview_data.dart';
import '../../../../core/constants/dashboard_backgrounds.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _aboutBio = TextEditingController();
  final _openingHours = TextEditingController();
  final _logoUrl = TextEditingController();
  final _coverUrl = TextEditingController();
  final _postalCode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _googleMapsUrl = TextEditingController();
  final _website = TextEditingController();
  BusinessType? _businessType;
  final _orderPhone = TextEditingController();
  final _contactEmail = TextEditingController();
  bool _initialized = false;
  bool _saving = false;
  PlatformFile? _logoFile;
  PlatformFile? _coverFile;
  String? _backgroundPresetId;
  String? _backgroundImageUrl;
  double _backgroundOverlayOpacity = DashboardBackgrounds.defaultOverlayOpacity;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _aboutBio.dispose();
    _openingHours.dispose();
    _logoUrl.dispose();
    _coverUrl.dispose();
    _postalCode.dispose();
    _city.dispose();
    _state.dispose();
    _googleMapsUrl.dispose();
    _website.dispose();
    _orderPhone.dispose();
    _contactEmail.dispose();
    super.dispose();
  }

  void _initFromBusiness() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    if (business == null || _initialized) return;
    _name.text = business.name;
    _description.text = business.description ?? '';
    _aboutBio.text = business.aboutBio ?? '';
    _openingHours.text = business.openingHours ?? '';
    _logoUrl.text = business.logoUrl ?? '';
    _coverUrl.text = business.coverImageUrl ?? '';
    final parsed = BusinessAddress.fromLegacyLocation(business.location);
    _postalCode.text = business.postalCode ?? '';
    _city.text = business.city?.trim().isNotEmpty == true
        ? business.city!.trim()
        : parsed.city;
    _state.text = business.state?.trim().isNotEmpty == true
        ? business.state!.trim()
        : parsed.state;
    _googleMapsUrl.text =
        extractGoogleMapsUrl(business.googleMapsUrl) ?? business.googleMapsUrl ?? '';
    _businessType = business.businessType;
    _website.text = business.website ?? '';
    _orderPhone.text = business.orderPhone ?? '';
    _contactEmail.text = business.contactEmail ?? '';
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

  ShopPreviewData _buildShopPreviewData() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    final l10n = context.l10n;
    return ShopPreviewData(
      name: _name.text.trim(),
      slug: business?.slug,
      heroTagline: _description.text.trim(),
      aboutBio: _aboutBio.text.trim(),
      logoUrl: _logoUrl.text.trim(),
      coverUrl: _coverUrl.text.trim(),
      postalCode: _postalCode.text.trim(),
      city: _city.text.trim(),
      state: _state.text.trim(),
      orderPhone: _orderPhone.text.trim(),
      contactEmail: _contactEmail.text.trim(),
      openingHours: _openingHours.text.trim(),
      website: _website.text.trim(),
      businessTypeLabel: _businessType?.label(l10n),
      siteConfig: business?.siteConfig,
    );
  }

  Future<void> _save() async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final aboutBioText = _aboutBio.text.trim();
    final descriptionText = _description.text.trim();
    final mapsRaw = _googleMapsUrl.text.trim();
    if (mapsRaw.isNotEmpty) {
      if (RegExp(r'<\s*iframe', caseSensitive: false).hasMatch(mapsRaw) ||
          mapsRaw.contains('</iframe>')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsGoogleMapsNoIframe),
            backgroundColor: context.appColors.danger,
          ),
        );
        return;
      }
      if (!isLikelyGoogleMapsUrl(mapsRaw)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsGoogleMapsUrlInvalid),
            backgroundColor: context.appColors.danger,
          ),
        );
        return;
      }
    }
    final mapsLink = normalizeGoogleMapsUrl(mapsRaw) ?? '';

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

      var coverImageUrl = _coverUrl.text.trim();
      if (_coverFile != null) {
        coverImageUrl = await ref.read(mediaUploadServiceProvider).uploadBusinessCover(
              businessId: businessId,
              file: _coverFile!,
            );
      } else if (coverImageUrl.isNotEmpty && coverImageUrl.contains('firebasestorage')) {
        coverImageUrl =
            await ref.read(mediaUploadServiceProvider).resolveImageUrl(coverImageUrl);
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
            description: descriptionText,
            logoUrl: logoUrl,
            coverImageUrl: coverImageUrl,
            postalCode: _postalCode.text.trim(),
            city: _city.text.trim(),
            state: _state.text.trim(),
            location: BusinessAddress.displayLocation(
              city: _city.text.trim(),
              state: _state.text.trim(),
            ),
            googleMapsUrl: mapsLink,
            aboutBio: aboutBioText.isNotEmpty ? aboutBioText : descriptionText,
            openingHours: _openingHours.text.trim(),
            businessType: _businessType,
            website: _website.text.trim(),
            backgroundPresetId: presetId,
            backgroundImageUrl: hasCustomBg ? customBg : null,
            backgroundOverlayOpacity: DashboardBackgrounds.hasActiveBackground(
              presetId: presetId,
              customImageUrl: hasCustomBg ? customBg : null,
            )
                ? _backgroundOverlayOpacity
                : null,
            orderPhone: _orderPhone.text.trim(),
            contactEmail: _contactEmail.text.trim(),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppearanceSection(),
            const SizedBox(height: 16),
            const ApiLanguagesSection(),
            const SizedBox(height: 16),
            const BusinessWebsiteSection(),
            if (business?.websitePlan == WebsitePlan.simple ||
                business?.siteConfig != null) ...[
              const SizedBox(height: 16),
              const BusinessSiteEditorSection(),
            ],
            const SizedBox(height: 16),
            if (ref.watch(businessPermissionsProvider).canManageTeam) ...[
              const TeamSection(),
              const SizedBox(height: 16),
            ],
            if (ref.watch(businessPermissionsProvider).canAccessBilling) ...[
              _PlanCard(),
              const SizedBox(height: 16),
            ],
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
              title: l10n.settingsPublicShopProfileTitle,
              subtitle: l10n.settingsPublicShopProfileSubtitle,
              icon: Icons.storefront_outlined,
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(label: l10n.settingsBusinessName, controller: _name),
                  const SizedBox(height: 20),
                  BusinessTypeDropdownField(
                    value: _businessType,
                    labelText: l10n.settingsBusinessType,
                    hint: l10n.businessTypeSelect,
                    onChanged: (v) => setState(() => _businessType = v),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsHeroTagline,
                    controller: _description,
                    hint: l10n.settingsHeroTaglineHint,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsAboutBio,
                    controller: _aboutBio,
                    hint: l10n.settingsAboutBioHint,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  ImageUrlUploadRow(
                    label: l10n.settingsLogoUrl,
                    urlController: _logoUrl,
                    onFilePicked: (f) => setState(() => _logoFile = f),
                    fileName: _logoFile?.name,
                  ),
                  const SizedBox(height: 20),
                  ImageUrlUploadRow(
                    label: l10n.settingsCoverUrl,
                    urlController: _coverUrl,
                    onFilePicked: (f) => setState(() => _coverFile = f),
                    fileName: _coverFile?.name,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsCoverNote,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsPostalCode,
                    controller: _postalCode,
                    hint: l10n.settingsPostalCodeHint,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsCity,
                    controller: _city,
                    hint: l10n.settingsCityHint,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsState,
                    controller: _state,
                    hint: l10n.settingsStateHint,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsLocationMaps,
                    controller: _googleMapsUrl,
                    hint: l10n.settingsLocationMapsHint,
                    keyboardType: TextInputType.url,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsLocationMapsNote,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsOpeningHours,
                    controller: _openingHours,
                    hint: l10n.settingsOpeningHoursHint,
                    maxLines: 4,
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
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsContactEmail,
                    controller: _contactEmail,
                    hint: 'info@biznesi.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsContactEmailNote,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: l10n.settingsWebsite,
                    controller: _website,
                    hint: 'https://example.com',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _saving
                                ? null
                                : () => showShopPreviewDialog(
                                      context,
                                      _buildShopPreviewData(),
                                    ),
                            icon: const Icon(Icons.visibility_outlined, size: 20),
                            label: Text(l10n.shopPreviewButton),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
