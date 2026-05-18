import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../i18n/app_locales.dart';
import '../l10n/l10n_extension.dart';
import '../theme/app_color_scheme.dart';
import '../utils/internal_slug.dart';
import 'app_text_field.dart';

/// Optional per-locale shop URL slugs (frontend only; internal slug stays canonical).
class LocalizedSlugsEditor extends StatefulWidget {
  const LocalizedSlugsEditor({
    super.key,
    required this.internalSlug,
    required this.defaultLocale,
    required this.enabledLocales,
    required this.values,
    required this.onChanged,
  });

  final String internalSlug;
  final String defaultLocale;
  final List<String> enabledLocales;
  final Map<String, String> values;
  final ValueChanged<Map<String, String>> onChanged;

  @override
  State<LocalizedSlugsEditor> createState() => _LocalizedSlugsEditorState();
}

class _LocalizedSlugsEditorState extends State<LocalizedSlugsEditor> {
  Map<String, TextEditingController> _controllers = {};

  List<String> get _optionalLocales {
    final set = AppLocales.normalizeList(widget.enabledLocales).toSet();
    return AppLocales.all
        .where((code) => set.contains(code) && code != widget.defaultLocale)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant LocalizedSlugsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values ||
        oldWidget.enabledLocales.join() != widget.enabledLocales.join()) {
      _syncControllers();
    }
  }

  void _syncControllers() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    final locales = _optionalLocales;
    _controllers = {
      for (final code in locales)
        code: TextEditingController(text: widget.values[code] ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _emit(String code, String raw) {
    final next = Map<String, String>.from(widget.values);
    final normalized = normalizeInternalSlug(raw);
    final internal = normalizeInternalSlug(widget.internalSlug);
    if (normalized.isEmpty || normalized == internal) {
      next.remove(code);
    } else {
      next[code] = normalized;
    }
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final optional = _optionalLocales;
    if (optional.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      title: Text(
        l10n.localizedSlugsSection,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      subtitle: Text(
        l10n.localizedSlugsHelper(widget.internalSlug),
        style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, height: 1.3),
      ),
      children: [
        for (final code in optional) ...[
          AppTextField(
            label: '${AppLocales.label(code)} URL slug',
            controller: _controllers[code],
            hint: widget.internalSlug,
            onChanged: (v) => _emit(code, v),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
