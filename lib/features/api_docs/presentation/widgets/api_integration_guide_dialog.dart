import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../domain/web_integration_guide.dart';

Future<void> showApiIntegrationGuideDialog(
  BuildContext context, {
  required String slug,
  required List<String> enabledLocales,
  required String defaultLocale,
}) {
  final l10n = context.l10n;
  final locale = Localizations.localeOf(context).languageCode;
  final text = WebIntegrationGuide.forLocale(
    locale,
    slug: slug,
    enabledLocales: enabledLocales,
    defaultLocale: defaultLocale,
  );

  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final colors = ctx.appColors;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.apiIntegrationInfoTitle,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.close,
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                  child: SelectableText(
                    text,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      height: 1.55,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
