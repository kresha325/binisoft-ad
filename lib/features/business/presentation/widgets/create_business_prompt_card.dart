import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';
import 'create_business_dialog.dart';

/// Shown on dashboard when the account has no active business yet.
class CreateBusinessPromptCard extends ConsumerWidget {
  const CreateBusinessPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: colors.accent.withValues(alpha: 0.35)),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.add_business_outlined, size: 40, color: colors.accent),
          const SizedBox(height: 16),
          Text(
            'Create your first business',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a business name and API slug to start managing products, categories, and your public catalog.',
            style: GoogleFonts.inter(fontSize: 15, color: colors.textMuted, height: 1.45),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => showCreateBusinessDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create new business'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: context.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
