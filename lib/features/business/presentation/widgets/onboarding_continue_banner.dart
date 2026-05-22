import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../providers/store_launch_readiness_provider.dart';

class OnboardingContinueBanner extends ConsumerWidget {
  const OnboardingContinueBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readiness = ref.watch(storeLaunchReadinessProvider);
    if (readiness == null || readiness.isComplete) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.rocket_launch_outlined, color: colors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingBannerTitle,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  l10n.onboardingBannerProgress(
                    readiness.completedCount,
                    readiness.totalCount,
                  ),
                  style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.go('/onboarding'),
            child: Text(l10n.onboardingBannerAction),
          ),
        ],
      ),
    );
  }
}
