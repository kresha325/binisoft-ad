import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../i18n/app_locales.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'app_text_field.dart';

/// Admin form fields per locale — one tab per language (SQ / EN / DE).
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

class _LocalizedFieldsEditorState extends State<LocalizedFieldsEditor>
    with SingleTickerProviderStateMixin {
  late final Map<String, TextEditingController> _controllers;
  late List<String> _locales;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _locales = _sortedLocales(widget.enabledLocales);
    _controllers = {
      for (final code in AppLocales.all)
        code: TextEditingController(text: widget.values[code] ?? ''),
    };
    _initTabs();
  }

  void _initTabs() {
    _tabController?.dispose();
    _tabController = TabController(length: _locales.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant LocalizedFieldsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextLocales = _sortedLocales(widget.enabledLocales);
    if (nextLocales.join() != _locales.join()) {
      _locales = nextLocales;
      _initTabs();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
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
    final tabController = _tabController;
    if (tabController == null || _locales.isEmpty) return const SizedBox.shrink();

    final fieldHeight = widget.multiline ? 132.0 : 76.0;

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
          'Only the default language is required. Other tabs are optional.',
          style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, height: 1.3),
        ),
        const SizedBox(height: 10),
        Material(
          color: colors.surfaceElevated.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                isScrollable: _locales.length > 3,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: [
                  for (final code in _locales)
                    Tab(text: AppLocales.label(code).toUpperCase()),
                ],
              ),
              SizedBox(
                height: fieldHeight,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    for (final code in _locales)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: AppTextField(
                          label: widget.label,
                          controller: _controllers[code]!,
                          hint: widget.label,
                          maxLines: widget.multiline ? 4 : 1,
                          onChanged: (_) => _emit(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
