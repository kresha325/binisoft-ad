import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../i18n/app_locales.dart';
import '../theme/app_color_scheme.dart';
import 'app_text_field.dart';

/// Admin form fields for sq / en / de (or subset from [enabledLocales]).
class LocalizedFieldsEditor extends StatefulWidget {
  const LocalizedFieldsEditor({
    super.key,
    required this.label,
    required this.enabledLocales,
    required this.values,
    required this.onChanged,
    this.multiline = false,
    this.requiredDefaultLocale = true,
  });

  final String label;
  final List<String> enabledLocales;
  final Map<String, String> values;
  final ValueChanged<Map<String, String>> onChanged;
  final bool multiline;
  final bool requiredDefaultLocale;

  @override
  State<LocalizedFieldsEditor> createState() => _LocalizedFieldsEditorState();
}

class _LocalizedFieldsEditorState extends State<LocalizedFieldsEditor> {
  late final Map<String, TextEditingController> _controllers;
  late List<String> _locales;

  @override
  void initState() {
    super.initState();
    _locales = _sortedLocales(widget.enabledLocales);
    _controllers = {
      for (final code in AppLocales.all)
        code: TextEditingController(text: widget.values[code] ?? ''),
    };
  }

  @override
  void didUpdateWidget(covariant LocalizedFieldsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextLocales = _sortedLocales(widget.enabledLocales);
    if (nextLocales.join() != _locales.join()) {
      _locales = nextLocales;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _sortedLocales(List<String> enabled) {
    final set = AppLocales.normalizeList(enabled).toSet();
    return AppLocales.all.where(set.contains).toList();
  }

  void _emit() {
    widget.onChanged({
      for (final code in AppLocales.all) code: _controllers[code]!.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fill only the languages you need. Default language is required.',
          style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, height: 1.3),
        ),
        const SizedBox(height: 10),
        for (final code in _locales) ...[
          AppTextField(
            label: AppLocales.label(code),
            controller: _controllers[code]!,
            hint: widget.label,
            maxLines: widget.multiline ? 3 : 1,
            onChanged: (_) => _emit(),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Validates that the default locale field is filled in.
String? validateLocalizedRequired({
  required Map<String, String> values,
  required String defaultLocale,
  required String fieldLabel,
}) {
  final v = values[defaultLocale]?.trim() ?? '';
  if (v.isEmpty) {
    return '$fieldLabel (${AppLocales.label(defaultLocale)}) is required';
  }
  return null;
}
