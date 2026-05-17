import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';

/// Single pricing card on the registration screen.
class RegisterPricingCard extends StatelessWidget {
  const RegisterPricingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.accent;
    final starter = BusinessPlan.defaultPlan;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(color: accent.withValues(alpha: 0.45), width: 1.5),
        boxShadow: AppShadows.card(context),
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(AppDesign.radiusSm),
            ),
            child: Text(
              'RECOMMENDED',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: accent,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Binisoft Admin',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your admin account, then add your business from the dashboard.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            starter.registrationPriceLabel,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: accent,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'then ${starter.priceLabel} · up to ${starter.maxProducts} products',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'First month included in registration',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.success,
            ),
          ),
          const SizedBox(height: 20),
          for (final f in starter.features.take(4))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 18, color: colors.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: colors.textPrimary,
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
