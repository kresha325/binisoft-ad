import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/default_attribute_templates.dart';
import '../../domain/entities/attribute_definition.dart';
import '../providers/attributes_providers.dart';

/// Checklist of predefined fields — enabled ones are required on Add Product.
class DefaultFieldsSection extends ConsumerStatefulWidget {
  const DefaultFieldsSection({super.key});

  @override
  ConsumerState<DefaultFieldsSection> createState() => _DefaultFieldsSectionState();
}

class _DefaultFieldsSectionState extends ConsumerState<DefaultFieldsSection> {
  String? _busyKey;

  Future<void> _toggle(
    DefaultAttributeTemplate template,
    bool enabled,
    List<AttributeDefinition> current,
  ) async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    setState(() => _busyKey = template.key);
    try {
      await ref.read(attributeRepositoryProvider).setTemplateEnabled(
            businessId: businessId,
            template: template,
            enabled: enabled,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyKey = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attributesAsync = ref.watch(attributesListProvider);
    final colors = context.appColors;

    final l10n = context.l10n;
    return AppSectionCard(
      title: l10n.defaultFieldsTitle,
      subtitle: l10n.defaultFieldsSubtitle,
      icon: Icons.checklist_rounded,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: attributesAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (e, _) => Text(
          'Could not load fields: $e',
          style: GoogleFonts.inter(fontSize: 13, color: colors.danger),
        ),
        data: (attributes) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final template in defaultAttributeTemplates)
              _DefaultFieldChip(
                template: template,
                selected: isDefaultTemplateEnabled(template, attributes),
                busy: _busyKey == template.key,
                onChanged: (v) => _toggle(template, v, attributes),
              ),
          ],
        ),
      ),
    );
  }
}

class _DefaultFieldChip extends StatelessWidget {
  const _DefaultFieldChip({
    required this.template,
    required this.selected,
    required this.busy,
    required this.onChanged,
  });

  final DefaultAttributeTemplate template;
  final bool selected;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent),
              ),
            ),
          Text(template.name),
          if (selected) ...[
            const SizedBox(width: 4),
            Text(
              context.l10n.defaultFieldRequired,
              style: GoogleFonts.inter(fontSize: 11, color: colors.success),
            ),
          ],
        ],
      ),
      selected: selected,
      onSelected: busy ? null : onChanged,
      selectedColor: colors.accentSoft,
      checkmarkColor: colors.accent,
      side: BorderSide(
        color: selected ? colors.accent.withValues(alpha: 0.35) : colors.cardBorder,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        color: colors.textPrimary,
      ),
    );
  }
}
