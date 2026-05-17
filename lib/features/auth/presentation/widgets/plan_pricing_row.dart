import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/theme/app_theme.dart';

/// Three plan cards in a row — each [Get started] selects plan and continues signup.
class PlanPricingRow extends StatelessWidget {
  const PlanPricingRow({
    super.key,
    required this.onGetStarted,
    this.selected,
  });

  final ValueChanged<BusinessPlan> onGetStarted;
  final BusinessPlan? selected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 900;

    if (horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < BusinessPlan.values.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Expanded(
              child: _PlanPricingCard(
                plan: BusinessPlan.values[i],
                selected: selected == BusinessPlan.values[i],
                onGetStarted: () => onGetStarted(BusinessPlan.values[i]),
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (var i = 0; i < BusinessPlan.values.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _PlanPricingCard(
            plan: BusinessPlan.values[i],
            selected: selected == BusinessPlan.values[i],
            onGetStarted: () => onGetStarted(BusinessPlan.values[i]),
          ),
        ],
      ],
    );
  }
}

class _PlanPricingCard extends StatelessWidget {
  const _PlanPricingCard({
    required this.plan,
    required this.selected,
    required this.onGetStarted,
  });

  final BusinessPlan plan;
  final bool selected;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final topFeatures = plan.features.take(4).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColors.navy : AppColors.cardBorder,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : AppShadows.authCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.navy.withValues(alpha: 0.06)
                  : const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.code,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  plan.registrationPriceLabel,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'then ${plan.priceLabel}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'First month included in registration',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greenBadge,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.summary,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final f in topFeatures)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          size: 16,
                          color: selected ? AppColors.greenBadge : AppColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textDark,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected ? AppColors.navy : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Get started',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
