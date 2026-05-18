import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../i18n/app_locales.dart';
import '../i18n/catalog_localized_content.dart';
import '../l10n/l10n_extension.dart';
import '../services/translation_service.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import 'app_text_field.dart';

/// Tabbed editor: per locale → Name, Description, SEO title, SEO description.
class LocalizedCatalogContentEditor extends ConsumerStatefulWidget {
  const LocalizedCatalogContentEditor({
    super.key,
    required this.businessId,
    required this.defaultLocale,
    required this.enabledLocales,
    required this.content,
    required this.onChanged,
    this.nameLabel,
    this.descriptionLabel,
    this.primaryTranslateKey = 'name',
  });

  final String businessId;
  final String defaultLocale;
  final List<String> enabledLocales;
  final CatalogLocalizedContent content;
  final ValueChanged<CatalogLocalizedContent> onChanged;
  final String? nameLabel;
  final String? descriptionLabel;

  /// API field name for the primary line (`name` for products/categories, `title` for offers).
  final String primaryTranslateKey;

  @override
  ConsumerState<LocalizedCatalogContentEditor> createState() =>
      _LocalizedCatalogContentEditorState();
}

class _LocalizedCatalogContentEditorState
    extends ConsumerState<LocalizedCatalogContentEditor>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late List<String> _locales;
  bool _translating = false;

  @override
  void initState() {
    super.initState();
    _locales = _sortedLocales(widget.enabledLocales);
    _tabController = TabController(length: _locales.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant LocalizedCatalogContentEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _sortedLocales(widget.enabledLocales);
    if (next.join() != _locales.join()) {
      _locales = next;
      _tabController?.dispose();
      _tabController = TabController(length: _locales.length, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<String> _sortedLocales(List<String> enabled) {
    final set = AppLocales.normalizeList(enabled).toSet();
    return AppLocales.all.where(set.contains).toList();
  }

  void _patch({
    Map<String, String>? name,
    Map<String, String>? description,
    Map<String, String>? seoTitle,
    Map<String, String>? seoDescription,
  }) {
    widget.onChanged(widget.content.copyWith(
      name: name,
      description: description,
      seoTitle: seoTitle,
      seoDescription: seoDescription,
    ));
  }

  Future<void> _autoTranslate() async {
    final l10n = context.l10n;
    final source = widget.defaultLocale;
    final targets = _locales.where((l) => l != source).toList();
    if (targets.isEmpty) return;

    final sourceFields = <String, String>{};
    void addIf(String key, Map<String, String> map) {
      final v = map[source]?.trim() ?? '';
      if (v.isNotEmpty) sourceFields[key] = v;
    }

    addIf(widget.primaryTranslateKey, widget.content.name);
    addIf('description', widget.content.description);
    addIf('seoTitle', widget.content.seoTitle);
    addIf('seoDescription', widget.content.seoDescription);

    if (sourceFields.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.autoTranslateNeedSource),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
      return;
    }

    setState(() => _translating = true);
    try {
      final translated = await ref.read(translationServiceProvider).translateCatalogFields(
            businessId: widget.businessId,
            sourceLocale: source,
            targetLocales: targets,
            fields: sourceFields,
          );

      var name = Map<String, String>.from(widget.content.name);
      var description = Map<String, String>.from(widget.content.description);
      var seoTitle = Map<String, String>.from(widget.content.seoTitle);
      var seoDescription = Map<String, String>.from(widget.content.seoDescription);

      for (final target in targets) {
        final block = translated[target];
        if (block == null) continue;
        for (final entry in block.entries) {
          if (entry.value.trim().isEmpty) continue;
          switch (entry.key) {
            case 'name':
            case 'title':
              if ((name[target]?.trim().isEmpty ?? true)) name[target] = entry.value;
            case 'description':
              if ((description[target]?.trim().isEmpty ?? true)) {
                description[target] = entry.value;
              }
            case 'seoTitle':
              if ((seoTitle[target]?.trim().isEmpty ?? true)) seoTitle[target] = entry.value;
            case 'seoDescription':
              if ((seoDescription[target]?.trim().isEmpty ?? true)) {
                seoDescription[target] = entry.value;
              }
          }
        }
      }

      _patch(
        name: name,
        description: description,
        seoTitle: seoTitle,
        seoDescription: seoDescription,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.autoTranslateDone)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _translating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final tabController = _tabController;
    if (tabController == null || _locales.isEmpty) return const SizedBox.shrink();

    final nameLabel = widget.nameLabel ?? l10n.productNameLabel;
    final descLabel = widget.descriptionLabel ?? l10n.productDescriptionLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.localizedContentSection,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: _translating ? null : _autoTranslate,
              icon: _translating
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.accent,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(l10n.autoTranslateButton),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.localizedContentHelper,
          style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted, height: 1.3),
        ),
        const SizedBox(height: 12),
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
                    Tab(
                      text: code == widget.defaultLocale
                          ? '${AppLocales.label(code).toUpperCase()} *'
                          : AppLocales.label(code).toUpperCase(),
                    ),
                ],
              ),
              SizedBox(
                height: 420,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    for (final code in _locales)
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _LocaleField(
                              label: nameLabel,
                              value: widget.content.name[code] ?? '',
                              required: code == widget.defaultLocale,
                              onChanged: (v) {
                                final next = Map<String, String>.from(widget.content.name);
                                next[code] = v;
                                _patch(name: next);
                              },
                            ),
                            const SizedBox(height: 12),
                            _LocaleField(
                              label: descLabel,
                              value: widget.content.description[code] ?? '',
                              multiline: true,
                              onChanged: (v) {
                                final next =
                                    Map<String, String>.from(widget.content.description);
                                next[code] = v;
                                _patch(description: next);
                              },
                            ),
                            const SizedBox(height: 12),
                            _LocaleField(
                              label: l10n.seoTitleLabel,
                              value: widget.content.seoTitle[code] ?? '',
                              onChanged: (v) {
                                final next =
                                    Map<String, String>.from(widget.content.seoTitle);
                                next[code] = v;
                                _patch(seoTitle: next);
                              },
                            ),
                            const SizedBox(height: 12),
                            _LocaleField(
                              label: l10n.seoDescriptionLabel,
                              value: widget.content.seoDescription[code] ?? '',
                              multiline: true,
                              onChanged: (v) {
                                final next = Map<String, String>.from(
                                  widget.content.seoDescription,
                                );
                                next[code] = v;
                                _patch(seoDescription: next);
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LocaleField extends StatefulWidget {
  const _LocaleField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.multiline = false,
    this.required = false,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool multiline;
  final bool required;

  @override
  State<_LocaleField> createState() => _LocaleFieldState();
}

class _LocaleFieldState extends State<_LocaleField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _LocaleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.required ? '${widget.label} *' : widget.label;
    return AppTextField(
      label: label,
      controller: _controller,
      maxLines: widget.multiline ? 3 : 1,
      onChanged: widget.onChanged,
    );
  }
}

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});
