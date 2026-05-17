import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../billing/domain/billing_company_info.dart';

/// Plans highlighted on the public landing page.
abstract final class LandingPricing {
  static const plans = [
    BusinessPlan.products100,
    BusinessPlan.products200,
    BusinessPlan.products500,
  ];

  static const enterpriseTitle = 'Enterprise';
  static const enterpriseTagline = 'Custom scale & dedicated support';
}

class LandingPricingSection extends StatelessWidget {
  const LandingPricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);
    final columns = isMobile ? 1 : (MediaQuery.sizeOf(context).width >= 1000 ? 4 : 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Pricing',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pay per catalog size · first month included with registration',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 15, color: colors.textMuted, height: 1.45),
        ),
        const SizedBox(height: 28),
        GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isMobile ? 0.68 : 0.58,
          children: [
            for (var i = 0; i < LandingPricing.plans.length; i++)
              _PlanCard(
                plan: LandingPricing.plans[i],
                featured: i == 0,
              ),
            const _EnterpriseCard(),
          ],
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, this.featured = false});

  final BusinessPlan plan;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(
          color: featured ? accent.withValues(alpha: 0.55) : colors.cardBorder,
          width: featured ? 1.5 : 1,
        ),
        boxShadow: featured
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (featured)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentSoft,
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
              ),
              child: Text(
                'MOST POPULAR',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          Text(
            plan.title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Up to ${plan.maxProducts} products',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            plan.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
          ),
          const SizedBox(height: 16),
          Text(
            plan.registrationPriceLabel,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'then ${plan.priceLabel}',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            '1st month included',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.success),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/register'),
            style: featured
                ? FilledButton.styleFrom(backgroundColor: accent)
                : null,
            child: const Text('Get started'),
          ),
        ],
      ),
    );
  }
}

class _EnterpriseCard extends StatelessWidget {
  const _EnterpriseCard();

  Future<void> _contactSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: BillingCompanyInfo.supportEmail,
      queryParameters: {
        'subject': 'Enterprise plan — Binisoft Admin',
        'body': 'Hi,\n\nI am interested in the Enterprise plan.\n\nCompany:\nCatalog size:\n\n',
      },
    );
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email us at ${BillingCompanyInfo.supportEmail}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.textPrimary.withValues(alpha: context.isDarkMode ? 0.35 : 0.92),
            colors.textPrimary.withValues(alpha: context.isDarkMode ? 0.55 : 1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(color: colors.cardBorder),
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LandingPricing.enterpriseTitle,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '1,000+ products · multi-team',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LandingPricing.enterpriseTagline,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          Text(
            'Custom pricing',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tailored to your volume',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          for (final line in const [
            'Dedicated onboarding',
            'Priority support',
            'Custom limits & SLA',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_rounded, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      line,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => _contactSupport(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
            ),
            child: const Text('Contact support'),
          ),
        ],
      ),
    );
  }
}
