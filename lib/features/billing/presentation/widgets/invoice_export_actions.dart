import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_locale_provider.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/ui_locales.dart';
import '../../../../core/widgets/export_language_picker_dialog.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_providers.dart';

class InvoiceExportActions extends ConsumerWidget {
  const InvoiceExportActions({
    super.key,
    required this.invoice,
    this.compact = false,
  });

  final Invoice invoice;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final export = ref.read(invoiceExportServiceProvider);
    final l10n = context.l10n;
    final defaultLang = UiLocales.codeOf(
      resolveAppLocale(ref.watch(appLocaleProvider)),
    );

    Future<void> runExport(Future<void> Function(String lang) action) async {
      final lang = await showExportLanguagePicker(
        context,
        initialCode: defaultLang,
      );
      if (lang == null) return;
      try {
        await action(lang);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.exportFailed('$e'))),
          );
        }
      }
    }

    if (compact) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded, size: 20),
        onSelected: (value) {
          if (value == 'download') {
            runExport((lang) => export.download(context, invoice, languageCode: lang));
          } else if (value == 'share') {
            runExport((lang) => export.share(invoice, languageCode: lang));
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'download', child: Text(l10n.downloadPdf)),
          PopupMenuItem(value: 'share', child: Text(l10n.sharePdf)),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => runExport(
              (lang) => export.download(context, invoice, languageCode: lang),
            ),
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(l10n.downloadPdf),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => runExport(
              (lang) => export.share(invoice, languageCode: lang),
            ),
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: Text(l10n.sharePdf),
          ),
        ),
      ],
    );
  }
}
