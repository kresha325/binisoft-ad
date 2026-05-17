import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';

class PlanSelector extends StatelessWidget {
  const PlanSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.compact = false,
    this.showFooterNote = true,
  });

  final BusinessPlan selected;
  final ValueChanged<BusinessPlan> onSelected;

  /// Shorter cards for dialogs (no long feature lists per plan).
  final bool compact;
  final bool showFooterNote;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Choose your plan', style: AppTextStyles.fieldLabel(context)),
        const SizedBox(height: 4),
        Text(
          '€30 + €6/month per 100 products (1st month included in registration). '
          'Max ${BusinessPricing.maxProductsPerBusiness} products per business.',
          style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
        ),
        const SizedBox(height: 14),
        if (compact)
          ...BusinessPlan.values.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CompactPlanCard(
                plan: plan,
                selected: selected == plan,
                onTap: () => onSelected(plan),
              ),
            ),
          )
        else
          ...BusinessPlan.values.expand(
            (plan) => [
              _PlanOptionCard(
                plan: plan,
                selected: selected == plan,
                onTap: () => onSelected(plan),
              ),
              const SizedBox(height: 12),
            ],
          ),
        if (compact) ...[
          const SizedBox(height: 8),
          _SelectedPlanDetails(plan: selected),
        ],
        if (showFooterNote) ...[
          const SizedBox(height: 12),
          Text(
            compact
                ? 'Billing integration coming soon. Limits apply immediately after update.'
                : 'You can register now and use your plan limits. Billing will be enabled later.',
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.4),
          ),
        ],
      ],
    );
  }
}

class _CompactPlanCard extends StatelessWidget {
  const _CompactPlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final BusinessPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colors.accentSoft : colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: selected ? accent : colors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? accent : colors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plan.title} · ${plan.maxProducts} products',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.description,
                      style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.registrationPriceLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  Text(
                    'then ${plan.priceLabel}',
                    style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPlanDetails extends StatelessWidget {
  const _SelectedPlanDetails({required this.plan});

  final BusinessPlan plan;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            plan.summary,
            style: GoogleFonts.inter(fontSize: 13, color: colors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 12),
          for (final f in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: colors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  const _PlanOptionCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final BusinessPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? colors.accentSoft : colors.surface,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: selected ? accent : colors.cardBorder,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected ? AppShadows.card(context) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 22,
                    color: selected ? accent : colors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              plan.title,
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              plan.code,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan.registrationPriceLabel,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                      Text(
                        'then ${plan.priceLabel}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                plan.summary,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.textPrimary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              ...plan.features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: selected ? colors.success : colors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.textMuted,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
