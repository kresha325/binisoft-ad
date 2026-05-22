import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/business_providers.dart';
import '../providers/store_launch_readiness_provider.dart';
import '../widgets/create_business_prompt_card.dart';

/// Guided setup before the store is public (no platform email or payments required).
class StoreOnboardingScreen extends ConsumerWidget {
  const StoreOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final hasBusiness = ref.watch(hasActiveBusinessProvider);
    final readiness = ref.watch(storeLaunchReadinessProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        actions: [
          if (hasBusiness && (readiness?.isComplete ?? false))
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: Text(l10n.onboardingGoDashboard),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.onboardingHeadline,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingSubtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: colors.textMuted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                if (!hasBusiness) ...[
                  const CreateBusinessPromptCard(),
                ] else if (readiness != null) ...[
                  _ProgressHeader(readiness: readiness),
                  const SizedBox(height: 20),
                  for (final task in readiness.tasks)
                    _OnboardingStepTile(
                      task: task,
                      label: _taskLabel(l10n, task.id),
                      onAction: () => _onTaskAction(context, ref, readiness, task),
                    ),
                  const SizedBox(height: 24),
                  if (readiness.isComplete)
                    FilledButton(
                      onPressed: () => context.go('/dashboard'),
                      child: Text(l10n.onboardingGoDashboard),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => context.go('/dashboard'),
                      icon: const Icon(Icons.dashboard_outlined, size: 20),
                      label: Text(l10n.onboardingContinueLater),
                    ),
                ] else
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _taskLabel(dynamic l10n, StoreLaunchTaskId id) => switch (id) {
        StoreLaunchTaskId.slug => l10n.storeLaunchTaskSlug,
        StoreLaunchTaskId.logo => l10n.storeLaunchTaskLogo,
        StoreLaunchTaskId.catalog => l10n.storeLaunchTaskCatalog,
        StoreLaunchTaskId.contact => l10n.storeLaunchTaskContact,
        StoreLaunchTaskId.preview => l10n.storeLaunchTaskPreview,
      };

  Future<void> _onTaskAction(
    BuildContext context,
    WidgetRef ref,
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

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.readiness});

  final StoreLaunchReadiness readiness;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: readiness.progress,
            minHeight: 8,
            backgroundColor: colors.cardBorder,
            color: colors.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${readiness.completedCount} / ${readiness.totalCount}',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.accent,
          ),
        ),
      ],
    );
  }
}

class _OnboardingStepTile extends StatelessWidget {
  const _OnboardingStepTile({
    required this.task,
    required this.label,
    required this.onAction,
  });

  final StoreLaunchTask task;
  final String label;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: InkWell(
          onTap: task.done ? null : onAction,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.done ? colors.success : colors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (!task.done)
                  Icon(Icons.chevron_right, color: colors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
