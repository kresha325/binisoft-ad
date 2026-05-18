import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../providers/business_providers.dart';

/// Shown on dashboard when an active store is selected (especially if multiple exist).
class ActiveStoreBanner extends ConsumerWidget {
  const ActiveStoreBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final owned = ref.watch(ownedBusinessesProvider).valueOrNull;
    if (business == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colors = context.appColors;
    final showHint = (owned?.length ?? 0) > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.storefront_outlined, size: 22, color: colors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.activeStoreBanner(business.name),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                if (showHint) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.activeStoreBannerHint,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showHint)
            TextButton(
              onPressed: () => context.go('/businesses'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(l10n.activeStoreBannerManage),
            ),
        ],
      ),
    );
  }
}
