import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/app_locales.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../../core/providers/firebase_providers.dart';

/// Choose which catalog languages the public API serves (?lang=).
class ApiLanguagesSection extends ConsumerStatefulWidget {
  const ApiLanguagesSection({super.key});

  @override
  ConsumerState<ApiLanguagesSection> createState() => _ApiLanguagesSectionState();
}

class _ApiLanguagesSectionState extends ConsumerState<ApiLanguagesSection> {
  final _enabled = <String>{};
  String _defaultLocale = AppLocales.defaultLocale;
  bool _initialized = false;
  bool _saving = false;

  void _initFromBusiness() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    if (business == null || _initialized) return;
    _enabled
      ..clear()
      ..addAll(business.locales);
    _defaultLocale = business.defaultLocale;
    if (!_enabled.contains(_defaultLocale) && _enabled.isNotEmpty) {
      _defaultLocale = _enabled.first;
    }
    _initialized = true;
  }

  String _catalogLabel(BuildContext context, String code) {
    final l10n = context.l10n;
    return switch (code) {
      AppLocales.sq => l10n.localeSq,
      AppLocales.de => l10n.localeDe,
      _ => l10n.localeEn,
    };
  }

  Future<void> _save() async {
    if (_enabled.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.apiLanguagesPickOne)),
      );
      return;
    }

    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final locales = AppLocales.all.where(_enabled.contains).toList();
    setState(() => _saving = true);
    try {
      await ref.read(businessRepositoryProvider).updateApiLocales(
            businessId: businessId,
            defaultLocale: _defaultLocale,
            locales: locales,
          );
      ref.invalidate(currentBusinessProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.apiLanguagesSaved)),
        );
      }
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
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final businessAsync = ref.watch(currentBusinessProvider);

    return businessAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (business) {
        if (business != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_initialized) setState(_initFromBusiness);
          });
        }

        return AppSectionCard(
          title: l10n.apiLanguagesTitle,
          subtitle: l10n.apiLanguagesSubtitle,
          icon: Icons.translate_rounded,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final code in AppLocales.all)
                CheckboxListTile(
                  value: _enabled.contains(code),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _enabled.add(code);
                      } else if (_enabled.length > 1) {
                        _enabled.remove(code);
                        if (_defaultLocale == code) {
                          _defaultLocale = _enabled.first;
                        }
                      }
                    });
                  },
                  title: Text(
                    _catalogLabel(context, code),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'API: ?lang=$code',
                    style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _enabled.contains(_defaultLocale)
                    ? _defaultLocale
                    : (_enabled.isNotEmpty ? _enabled.first : AppLocales.defaultLocale),
                decoration: InputDecoration(
                  labelText: l10n.apiLanguagesDefault,
                  labelStyle: GoogleFonts.inter(color: colors.textMuted),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: [
                  for (final code in AppLocales.all.where(_enabled.contains))
                    DropdownMenuItem(
                      value: code,
                      child: Text(_catalogLabel(context, code)),
                    ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _defaultLocale = v);
                },
              ),
              const SizedBox(height: 8),
              Text(
                l10n.apiLanguagesHint,
                style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.apiLanguagesSave),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
