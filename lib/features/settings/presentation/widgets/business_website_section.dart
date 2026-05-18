import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/services/site_deploy_service.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../billing/domain/billing_company_info.dart';
import '../../../business/domain/entities/website_plan.dart';
import '../../../business/presentation/providers/business_providers.dart';

final siteDeployServiceProvider = Provider((ref) => SiteDeployService());

class BusinessWebsiteSection extends ConsumerStatefulWidget {
  const BusinessWebsiteSection({super.key});

  @override
  ConsumerState<BusinessWebsiteSection> createState() => _BusinessWebsiteSectionState();
}

class _BusinessWebsiteSectionState extends ConsumerState<BusinessWebsiteSection> {
  final _customDomain = TextEditingController();
  bool _initialized = false;
  bool _deploying = false;
  bool _savingPlan = false;
  SiteDeployResult? _lastDeploy;
  WebsitePlan? _selectedPlan;

  @override
  void dispose() {
    _customDomain.dispose();
    super.dispose();
  }

  void _initFromBusiness() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    if (business == null || _initialized) return;
    _customDomain.text = business.siteCustomDomain ?? '';
    _selectedPlan = business.websitePlan ??
        (business.siteDeployUrl != null && business.siteDeployUrl!.isNotEmpty
            ? WebsitePlan.simple
            : null);
    _initialized = true;
  }

  String _liveUrl(String? slug) {
    if (slug == null || slug.isEmpty) return '';
    final stored = ref.read(currentBusinessProvider).valueOrNull?.siteDeployUrl;
    if (stored != null && stored.isNotEmpty) return stored;
    return AppConstants.publicShopUrl(slug);
  }

  Future<void> _selectPlan(WebsitePlan plan) async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    setState(() {
      _selectedPlan = plan;
      _savingPlan = true;
    });
    try {
      await ref.read(businessRepositoryProvider).updateWebsitePlan(
            businessId: businessId,
            plan: plan,
            markProfessionalRequested: plan == WebsitePlan.professional,
          );
      ref.invalidate(currentBusinessProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _savingPlan = false);
    }
  }

  Future<void> _deploy() async {
    final businessId = ref.read(currentBusinessIdProvider);
    final slug = ref.read(currentBusinessProvider).valueOrNull?.slug;
    if (businessId == null || slug == null || slug.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.websiteSlugRequired)),
      );
      return;
    }

    setState(() => _deploying = true);
    try {
      if (_selectedPlan != WebsitePlan.simple) {
        await ref.read(businessRepositoryProvider).updateWebsitePlan(
              businessId: businessId,
              plan: WebsitePlan.simple,
            );
        _selectedPlan = WebsitePlan.simple;
      }
      final result = await ref.read(siteDeployServiceProvider).deploySite(
            businessId: businessId,
            customDomain: _customDomain.text,
          );
      ref.invalidate(currentBusinessProvider);
      if (mounted) {
        setState(() => _lastDeploy = result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.websiteDeploySuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _deploying = false);
    }
  }

  Future<void> _contactForProfessional() async {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId != null) {
      await ref.read(businessRepositoryProvider).updateWebsitePlan(
            businessId: businessId,
            plan: WebsitePlan.professional,
            markProfessionalRequested: true,
          );
      ref.invalidate(currentBusinessProvider);
    }

    final name = business?.name ?? '';
    final slug = business?.slug ?? '';
    final uri = Uri(
      scheme: 'mailto',
      path: BillingCompanyInfo.supportEmail,
      queryParameters: {
        'subject': 'Professional website — $name',
        'body':
            'Hi Binisoft,\n\nI would like a professional custom website for my business.\n\n'
            'Business: $name\n'
            'Store slug: $slug\n\n'
            'Goals / style:\n\n'
            'Domain:\n\n',
      },
    );
    if (!await launchUrl(uri) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.websiteProContactEmail}: ${BillingCompanyInfo.supportEmail}',
          ),
        ),
      );
    }
    if (mounted) {
      setState(() => _selectedPlan = WebsitePlan.professional);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final slug = business?.slug;
    final liveUrl = _liveUrl(slug);
    final plan = _selectedPlan ?? business?.websitePlan;

    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromBusiness());

    return AppSectionCard(
      title: l10n.websiteSectionTitle,
      subtitle: l10n.websiteSectionSubtitle,
      icon: Icons.language_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.websiteChoosePlan,
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _PlanOptionCard(
            selected: plan == WebsitePlan.simple,
            loading: _savingPlan && plan != WebsitePlan.professional,
            icon: Icons.storefront_outlined,
            title: l10n.websiteSimpleTitle,
            badge: l10n.websiteSimpleBadge,
            description: l10n.websiteSimpleDescription,
            features: [
              l10n.websiteSimpleFeature1,
              l10n.websiteSimpleFeature2,
              l10n.websiteSimpleFeature3,
            ],
            onTap: () => _selectPlan(WebsitePlan.simple),
          ),
          const SizedBox(height: 12),
          _PlanOptionCard(
            selected: plan == WebsitePlan.professional,
            loading: _savingPlan && plan != WebsitePlan.simple,
            icon: Icons.auto_awesome_outlined,
            title: l10n.websiteProTitle,
            badge: l10n.websiteProBadge,
            description: l10n.websiteProDescription,
            features: [
              l10n.websiteProFeature1,
              l10n.websiteProFeature2,
              l10n.websiteProFeature3,
            ],
            onTap: () => _selectPlan(WebsitePlan.professional),
          ),
          if (plan == null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.websiteChoosePlanHint,
              style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
            ),
          ],
          if (plan == WebsitePlan.simple) ...[
            const SizedBox(height: 24),
            Divider(color: colors.cardBorder),
            const SizedBox(height: 20),
            Text(
              l10n.websiteSimpleSetupTitle,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.websiteSimpleSetupNote,
              style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            _InfoTile(
              label: l10n.websiteTemplateLabel,
              value: l10n.websiteSimpleTemplateName,
            ),
            const SizedBox(height: 12),
            if (slug != null && slug.isNotEmpty) ...[
              _InfoTile(label: l10n.websiteLiveUrlLabel, value: liveUrl),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => launchUrl(Uri.parse(liveUrl)),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(l10n.websiteOpenSite),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: liveUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.websiteLinkCopied)),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(l10n.websiteCopyLink),
                  ),
                ],
              ),
            ] else
              Text(
                l10n.websiteSlugRequired,
                style: GoogleFonts.inter(fontSize: 13, color: colors.danger),
              ),
            if (business?.siteLastDeployAt != null) ...[
              const SizedBox(height: 12),
              Text(
                '${l10n.websiteLastDeploy}: ${DateFormat('d MMM yyyy, HH:mm').format(business!.siteLastDeployAt!)}',
                style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
              ),
            ],
            const SizedBox(height: 20),
            AppTextField(
              label: l10n.websiteCustomDomainLabel,
              controller: _customDomain,
              hint: 'www.dyqani-im.com',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.websiteCustomDomainNote,
              style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _deploying || slug == null ? null : _deploy,
                icon: _deploying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.rocket_launch_outlined),
                label: Text(l10n.websiteGenerateSimple),
              ),
            ),
            if (_lastDeploy != null && _lastDeploy!.dnsRecords.isNotEmpty) ...[
              const SizedBox(height: 20),
              _DnsBox(records: _lastDeploy!.dnsRecords, title: l10n.websiteDnsTitle),
            ],
          ],
          if (plan == WebsitePlan.professional) ...[
            const SizedBox(height: 24),
            Divider(color: colors.cardBorder),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.websiteProContactTitle,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.websiteProContactBody,
                    style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted, height: 1.45),
                  ),
                  if (business?.professionalWebsiteRequestedAt != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.websiteProRequested}: ${DateFormat('d MMM yyyy').format(business!.professionalWebsiteRequestedAt!)}',
                      style: GoogleFonts.inter(fontSize: 12, color: colors.accent),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _contactForProfessional,
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: Text(l10n.websiteProContactButton),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    BillingCompanyInfo.supportEmail,
                    style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  const _PlanOptionCard({
    required this.selected,
    required this.loading,
    required this.icon,
    required this.title,
    required this.badge,
    required this.description,
    required this.features,
    required this.onTap,
  });

  final bool selected;
  final bool loading;
  final IconData icon;
  final String title;
  final String badge;
  final String description;
  final List<String> features;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: selected ? colors.accent.withValues(alpha: 0.08) : colors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: selected ? colors.accent : colors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: selected ? colors.accent : colors.textMuted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? colors.accent : colors.cardBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : colors.textMuted,
                      ),
                    ),
                  ),
                  if (loading) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 10),
              for (final f in features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, size: 16, color: colors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: GoogleFonts.inter(fontSize: 12, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted)),
        const SizedBox(height: 4),
        SelectableText(
          value,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DnsBox extends StatelessWidget {
  const _DnsBox({required this.records, required this.title});

  final List<SiteDnsRecord> records;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final r in records) ...[
            SelectableText(
              '${r.type}  ${r.name}  →  ${r.value}',
              style: GoogleFonts.robotoMono(fontSize: 12),
            ),
            if (r.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  r.note!,
                  style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
