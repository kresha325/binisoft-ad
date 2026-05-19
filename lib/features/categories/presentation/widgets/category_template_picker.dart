import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../business/domain/entities/business_type.dart';
import '../../domain/business_category_templates.dart';
import '../../domain/entities/category.dart';

/// Chips to pre-fill a new category from [BusinessType] templates.
class CategoryTemplatePicker extends StatelessWidget {
  const CategoryTemplatePicker({
    super.key,
    required this.businessType,
    required this.existingCategories,
    required this.defaultLocale,
    required this.onSelected,
  });

  final BusinessType? businessType;
  final List<Category> existingCategories;
  final String defaultLocale;
  final ValueChanged<CategoryTemplateSuggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final existingSlugs = existingCategories.map((c) => c.slug).toSet();

    final suggestions = BusinessCategoryTemplates.forType(businessType)
        .where((t) => !existingSlugs.contains(t.slug))
        .toList();

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.categoryTemplatesTitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in suggestions)
              ActionChip(
                label: Text(t.nameFor(defaultLocale)),
                onPressed: () => onSelected(t),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
