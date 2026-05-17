import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/order_providers.dart';

class ApiKeysSection extends ConsumerWidget {
  const ApiKeysSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final keysAsync = ref.watch(businessApiKeysProvider);

    return AppSectionCard(
      title: 'Order API keys',
      subtitle:
          'Generate a key for each client website. Use Authorization: Bearer <key> on POST /orders.',
      icon: Icons.vpn_key_outlined,
      child: keysAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('$e', style: TextStyle(color: colors.danger)),
        data: (keys) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => _createKey(context, ref),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Generate API key'),
              ),
              const SizedBox(height: 16),
              if (keys.isEmpty)
                Text(
                  'No keys yet. Create one and paste it into your e-commerce site config.',
                  style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                )
              else
                ...keys.map((k) {
                  final created = DateFormat('d MMM yyyy').format(k.createdAt);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.cardBorder),
                      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                k.name,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${k.keyPrefix} · $created'
                                '${k.active ? '' : ' · revoked'}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (k.active)
                          TextButton(
                            onPressed: () => _revoke(context, ref, k.id),
                            child: Text('Revoke', style: TextStyle(color: colors.danger)),
                          ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createKey(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController(text: 'E-commerce site');
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New API key'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Label (e.g. client shop)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, nameCtrl.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || !context.mounted) return;

    try {
      final created = await ref.read(apiKeyRepositoryProvider).createKey(
            businessId: businessId,
            name: name,
          );
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Copy your API key'),
          content: SelectableText(
            created.plainKey,
            style: GoogleFonts.robotoMono(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: created.plainKey));
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Copied')),
                );
              },
              child: const Text('Copy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _revoke(BuildContext context, WidgetRef ref, String keyId) async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;
    try {
      await ref.read(apiKeyRepositoryProvider).revokeKey(
            businessId: businessId,
            keyId: keyId,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
