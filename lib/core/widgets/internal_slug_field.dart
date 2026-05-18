import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_color_scheme.dart';
import '../utils/internal_slug.dart';
import 'app_text_field.dart';

/// Internal slug for catalog entities (not translated; used in API & DB).
class InternalSlugField extends StatelessWidget {
  const InternalSlugField({
    super.key,
    required this.controller,
    required this.readOnly,
    this.onChanged,
    this.onManualEdit,
  });

  final TextEditingController controller;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onManualEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: l10n.internalSlugLabel,
          controller: controller,
          hint: l10n.internalSlugHint,
          helperText: readOnly ? l10n.internalSlugImmutableHelper : l10n.internalSlugHelper,
          onChanged: readOnly
              ? null
              : (v) {
                  onManualEdit?.call();
                  onChanged?.call(v);
                },
        ),
        if (readOnly) ...[
          const SizedBox(height: 6),
          Text(
            l10n.internalSlugImmutableNote,
            style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, height: 1.3),
          ),
        ],
      ],
    );
  }
}

/// Validates slug field; shows snackbar-style message via return value.
String? validateInternalSlugField(String raw) => validateInternalSlug(raw);
