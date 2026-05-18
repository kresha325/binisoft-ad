import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../orders/data/models/api_key_model.dart';
import '../providers/superadmin_providers.dart';
import '../../domain/superadmin_models.dart';

/// One API key + shop URL bundle per business (platform admin).
class SuperAdminShopApiTab extends ConsumerStatefulWidget {
  const SuperAdminShopApiTab({super.key});

  @override
  ConsumerState<SuperAdminShopApiTab> createState() => _SuperAdminShopApiTabState();
}

class _SuperAdminShopApiTabState extends ConsumerState<SuperAdminShopApiTab> {
  String? _selectedBusinessId;

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(superAdminBusinessesProvider);
    final colors = context.appColors;

    return businessesAsync.when(
      loading: () => const LoadingOverlay(message: 'Loading businesses…'),
      error: (e, _) => Center(child: Text('$e', style: TextStyle(color: colors.danger))),
      data: (businesses) {
        if (businesses.isEmpty) {
          return Center(
            child: Text(
              'No businesses yet.',
              style: GoogleFonts.inter(color: colors.textMuted),
            ),
          );
        }

        final selectedId = _selectedBusinessId ?? businesses.first.id;
        final selected = businesses.firstWhere(
          (b) => b.id == selectedId,
          orElse: () => businesses.first,
        );

        if (_selectedBusinessId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _selectedBusinessId = selected.id);
          });
        }

        final slug = selected.slug?.trim() ?? '';
        final keysAsync = ref.watch(superAdminBusinessApiKeysProvider(selected.id));

        return ListView(
          children: [
            AppSectionCard(
              title: 'Shop API (publik)',
              subtitle:
                  'Dyqani përdor /api/shop/* — businesses, products, categories, offers. Porositë: /api/shop/checkout (pa key për klientët).',
              icon: Icons.storefront_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey(selected.id),
                    initialValue: selected.id,
                    decoration: const InputDecoration(
                      labelText: 'Biznesi',
                      border: OutlineInputBorder(),
                    ),
                    items: businesses
                        .map(
                          (b) => DropdownMenuItem(
                            value: b.id,
                            child: Text('${b.name}${b.slug != null ? ' (/${b.slug})' : ''}'),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      if (id != null) setState(() => _selectedBusinessId = id);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (slug.isEmpty)
                    Text(
                      'Ky biznes nuk ka slug. Vendos slug në admin që dyqani të hapet në /slug.',
                      style: GoogleFonts.inter(fontSize: 13, color: colors.danger),
                    )
                  else ...[
                    _CopyRow(
                      label: 'URL dyqani',
                      value: AppConstants.publicShopUrl(slug),
                    ),
                    const SizedBox(height: 10),
                    _CopyRow(
                      label: 'URL me API (hap një herë)',
                      value:
                          '${AppConstants.publicShopUrl(slug)}?key=PASTE_KEY_AFTER_CREATE',
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: slug.isEmpty
                        ? null
                        : () => _createShopKey(context, selected),
                    icon: const Icon(Icons.vpn_key_outlined, size: 20),
                    label: const Text('Krijo API key për dyqanin'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppSectionCard(
              title: 'Çelësat ekzistues',
              subtitle: 'Një key aktiv mjafton për integrimin e shop-it.',
              icon: Icons.key_outlined,
              child: keysAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('$e', style: TextStyle(color: colors.danger)),
                data: (keys) {
                  if (keys.isEmpty) {
                    return Text(
                      'Nuk ka key. Krijo një key më sipër.',
                      style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                    );
                  }
                  return Column(
                    children: keys.map((k) => _KeyTile(businessId: selected.id, record: k)).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppSectionCard(
              title: 'Konfigurim .env (shop)',
              subtitle: 'Vetëm këto 3 rreshta pas krijimit të key-it.',
              icon: Icons.code_outlined,
              child: SelectableText(
                slug.isEmpty
                    ? '—'
                    : _envBlock(slug),
                style: GoogleFonts.robotoMono(fontSize: 12, height: 1.5),
              ),
            ),
          ],
        );
      },
    );
  }

  String _envBlock(String slug) {
    final shopOrigin = AppConstants.publicShopBaseUrl;
    final fn = AppConstants.shopApiBaseUrl;
    return '''# Shop app — platform catalog API
VITE_API_BASE_URL=
VITE_BUSINESS_SLUG=$slug

# On shop hosting ($shopOrigin):
# GET /api/shop/businesses
# GET /api/shop/$slug/products
# GET /api/shop/$slug/categories
# GET /api/shop/$slug/offers
# GET /api/shop/$slug/business
# POST /api/shop/checkout

# Direct (dev): $fn/api/shop/...''';
  }

  Future<void> _createShopKey(BuildContext context, SuperAdminBusinessRow business) async {
    final slug = business.slug?.trim();
    if (slug == null || slug.isEmpty) return;

    try {
      final created = await ref.read(apiKeyRepositoryProvider).createKey(
            businessId: business.id,
            name: 'Public shop',
          );

      if (!context.mounted) return;

      final bundle = '''# Shop — ${business.name}
${_envBlock(slug)}

# Opsional — integrime të jashtme:
# VITE_API_KEY=${created.plainKey}

${AppConstants.publicShopUrl(slug)}
''';

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('API key u krijua'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kopjo këtë key tani — nuk shfaqet përsëri.',
                  style: GoogleFonts.inter(fontSize: 13, color: context.appColors.textMuted),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  created.plainKey,
                  style: GoogleFonts.robotoMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.accent,
                  ),
                ),
                const SizedBox(height: 16),
                SelectableText(bundle, style: GoogleFonts.robotoMono(fontSize: 11, height: 1.45)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: bundle));
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('U kopjua integrimi')),
                );
              },
              child: const Text('Kopjo të gjitha'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mbyll'),
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
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted)),
              const SizedBox(height: 4),
              SelectableText(
                value,
                style: GoogleFonts.robotoMono(fontSize: 12, color: colors.textPrimary),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Kopjo',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('U kopjua')),
            );
          },
          icon: const Icon(Icons.copy_rounded, size: 20),
        ),
      ],
    );
  }
}

class _KeyTile extends ConsumerWidget {
  const _KeyTile({required this.businessId, required this.record});

  final String businessId;
  final BusinessApiKeyRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final created = DateFormat('d MMM yyyy').format(record.createdAt);

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
                Text(record.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                Text(
                  '${record.keyPrefix} · $created${record.active ? '' : ' · revoked'}',
                  style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          ),
          if (record.active)
            TextButton(
              onPressed: () async {
                await ref.read(apiKeyRepositoryProvider).revokeKey(
                      businessId: businessId,
                      keyId: record.id,
                    );
              },
              child: Text('Revoke', style: TextStyle(color: colors.danger)),
            ),
        ],
      ),
    );
  }
}
