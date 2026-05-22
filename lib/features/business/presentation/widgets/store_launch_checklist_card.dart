import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:business_dashboard/l10n/app_localizations.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../providers/store_launch_readiness_provider.dart';

/// Onboarding checklist for publishing the public store (web + mobile admin).
class StoreLaunchChecklistCard extends ConsumerWidget {
  const StoreLaunchChecklistCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readiness = ref.watch(storeLaunchReadinessProvider);
    if (readiness == null || readiness.isComplete) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.rocket_launch_outlined, size: 22, color: colors.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.storeLaunchChecklistTitle,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${readiness.completedCount}/${readiness.totalCount}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.storeLaunchChecklistSubtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: readiness.progress,
              minHeight: 6,
              backgroundColor: colors.cardBorder,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 14),
          for (final task in readiness.tasks)
            _TaskRow(
              task: task,
              label: _labelFor(l10n, task.id),
              colors: colors,
              onAction: () => _onTaskTap(context, readiness, task),
            ),
        ],
      ),
    );
  }

  String _labelFor(AppLocalizations l10n, StoreLaunchTaskId id) => switch (id) {
        StoreLaunchTaskId.slug => l10n.storeLaunchTaskSlug,
        StoreLaunchTaskId.logo => l10n.storeLaunchTaskLogo,
        StoreLaunchTaskId.catalog => l10n.storeLaunchTaskCatalog,
        StoreLaunchTaskId.contact => l10n.storeLaunchTaskContact,
        StoreLaunchTaskId.preview => l10n.storeLaunchTaskPreview,
      };

  Future<void> _onTaskTap(
    BuildContext context,
    StoreLaunchReadiness readiness,
    StoreLaunchTask task,
  ) async {
    if (task.id == StoreLaunchTaskId.preview) {
      final slug = readiness.storeSlug;
      if (slug == null) return;
      final uri = Uri.parse(AppConstants.publicShopUrl(slug));
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }
    final route = task.route;
    if (route != null && context.mounted) context.go(route);
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.label,
    required this.colors,
    required this.onAction,
  });

  final StoreLaunchTask task;
  final String label;
  final AppColorScheme colors;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 22,
                  color: task.done ? colors.success : colors.textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      decorationColor: colors.textMuted,
                    ),
                  ),
                ),
                if (!task.done)
                  Icon(Icons.chevron_right, size: 20, color: colors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
