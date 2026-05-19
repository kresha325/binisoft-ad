import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/open_external_url.dart';
import '../../../../core/i18n/app_locales.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../services/presentation/providers/services_providers.dart';
import '../../../products/presentation/providers/attributes_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../orders/presentation/widgets/api_keys_section.dart';
import '../../domain/public_api_serializer.dart';
import '../widgets/api_integration_guide_dialog.dart';

class ApiDocsScreen extends ConsumerStatefulWidget {
  const ApiDocsScreen({super.key});

  @override
  ConsumerState<ApiDocsScreen> createState() => _ApiDocsScreenState();
}

class _ApiDocsScreenState extends ConsumerState<ApiDocsScreen> {
  String? _previewJson;
  String? _previewSource;
  bool _loadingPreview = false;
  bool _autoPreviewAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoPreview());
  }

  String _productsUrl(String slug, {String? lang}) {
    final base = '${AppConstants.publicApiBaseUrl}/api/public/$slug/products';
    if (lang == null || lang.isEmpty) return base;
    return '$base?lang=$lang';
  }

  String _categoriesUrl(String slug, {String? lang}) {
    final base = '${AppConstants.publicApiBaseUrl}/api/public/$slug/categories';
    if (lang == null || lang.isEmpty) return base;
    return '$base?lang=$lang';
  }

  String _offersUrl(String slug, {String? lang}) {
    final base = '${AppConstants.publicApiBaseUrl}/api/public/$slug/offers';
    if (lang == null || lang.isEmpty) return base;
    return '$base?lang=$lang';
  }

  String _servicesUrl(String slug, {String? lang}) {
    final base = '${AppConstants.publicApiBaseUrl}/api/public/$slug/services';
    if (lang == null || lang.isEmpty) return base;
    return '$base?lang=$lang';
  }

  String _productUrl(String slug, String id, {String? lang}) {
    final base =
        '${AppConstants.publicApiBaseUrl}/api/public/$slug/products/$id';
    if (lang == null || lang.isEmpty) return base;
    return '$base?lang=$lang';
  }

  String _ordersUrl(String slug) =>
      '${AppConstants.publicApiBaseUrl}/api/public/$slug/orders';

  static const _orderBodySample = '''
{
  "customer": {
    "name": "Arben Krasniqi",
    "phone": "+38344123456",
    "notes": "Delivery after 18:00"
  },
  "lines": [
    { "productId": "PRODUCT_ID", "quantity": 2 }
  ],
  "channel": "whatsapp"
}''';

  Future<void> _loadPreview(String slug, {String? lang}) async {
    setState(() {
      _loadingPreview = true;
      _previewSource = null;
    });

    try {
      final response = await http.get(Uri.parse(_productsUrl(slug, lang: lang)));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _previewJson = const JsonEncoder.withIndent('  ').convert(decoded);
          _previewSource = 'Live API';
          _loadingPreview = false;
        });
        return;
      }
    } catch (_) {}

    if (!mounted) return;

    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) {
      if (mounted) setState(() => _loadingPreview = false);
      return;
    }

    final business = ref.read(currentBusinessProvider).valueOrNull;
    final products = ref.read(productsListProvider).valueOrNull ?? [];
    final categories = ref.read(categoriesListProvider).valueOrNull ?? [];
    final attributes = ref.read(attributesListProvider).valueOrNull ?? [];

    final payload = buildPublicProductsPayload(
      business: business,
      slug: slug,
      categories: categories,
      attributes: attributes,
      products: products,
      locale: lang ?? business?.defaultLocale,
    );

    setState(() {
      _previewJson = const JsonEncoder.withIndent('  ').convert(payload);
      _previewSource = 'Local preview (deploy publicApi for live URL)';
      _loadingPreview = false;
    });
  }

  void _tryAutoPreview() {
    if (_autoPreviewAttempted || _loadingPreview) return;
    final business = ref.read(currentBusinessProvider).valueOrNull;
    final slug = business?.slug;
    if (slug == null || slug.isEmpty) return;
    _autoPreviewAttempted = true;
    _loadPreview(slug, lang: business!.defaultLocale);
  }

  void _showIntegrationGuide(
    BuildContext context, {
    required String slug,
    required List<String> enabledLocales,
    required String defaultLocale,
  }) {
    showApiIntegrationGuideDialog(
      context,
      slug: slug,
      enabledLocales: enabledLocales,
      defaultLocale: defaultLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final business = ref.watch(currentBusinessProvider).valueOrNull;
    final slug = business?.slug ?? 'your-slug';

    ref.listen(currentBusinessProvider, (previous, next) {
      final prevSlug = previous?.valueOrNull?.slug;
      final nextSlug = next.valueOrNull?.slug;
      if (nextSlug == null || nextSlug.isEmpty) return;
      if (prevSlug != nextSlug) {
        _loadPreview(nextSlug, lang: next.valueOrNull!.defaultLocale);
      } else if (!_autoPreviewAttempted) {
        _tryAutoPreview();
      }
    });

    final enabledLocales =
        business?.locales ?? List<String>.from(AppLocales.all);
    final defaultLang = business?.defaultLocale ?? AppLocales.defaultLocale;

    final endpoints = <_Endpoint>[
      for (final lang in enabledLocales) ...[
        _Endpoint(
          method: 'GET',
          path: '/api/public/$slug/products?lang=$lang',
          description:
              'Active catalog in ${AppLocales.label(lang)}. Use this URL when your shop/app is in ${AppLocales.label(lang)}.',
          url: _productsUrl(slug, lang: lang),
          onPreview: lang == defaultLang ? () => _loadPreview(slug, lang: lang) : null,
        ),
        _Endpoint(
          method: 'GET',
          path: '/api/public/$slug/categories?lang=$lang',
          description: 'Categories in ${AppLocales.label(lang)}.',
          url: _categoriesUrl(slug, lang: lang),
        ),
        _Endpoint(
          method: 'GET',
          path: '/api/public/$slug/services?lang=$lang',
          description:
              'Active services (${AppLocales.label(lang)}): name, description, duration, price. '
              'Use for booking pages or service menus.',
          url: _servicesUrl(slug, lang: lang),
        ),
        _Endpoint(
          method: 'GET',
          path: '/api/public/$slug/offers?lang=$lang',
          description:
              'Active offers (${AppLocales.label(lang)}). Your shop decides how to display them. '
              'Products also include onOffer, originalPrice, and sale price when applicable.',
          url: _offersUrl(slug, lang: lang),
        ),
        _Endpoint(
          method: 'GET',
          path: '/api/public/$slug/products/{id}?lang=$lang',
          description: 'Single active product (${AppLocales.label(lang)}).',
          url: _productUrl(slug, '{productId}', lang: lang),
        ),
      ],
      _Endpoint(
        method: 'POST',
        path: '/api/public/$slug/orders',
        description:
            'Submit an order from your e-commerce or menu site. Requires API key '
            '(Authorization: Bearer <key>). Returns orderId, messageText, and whatsAppUrl/smsUrl. '
            'Prices use active offers when applicable (server-side).',
        url: _ordersUrl(slug),
        bodySample: _orderBodySample,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
              AppInfoBanner(
                icon: Icons.cloud_upload_outlined,
                message:
                    'Deploy: firebase deploy --project=jon-sport --only functions:publicApi\n'
                    'Catalog URLs use ?lang= (configured in Settings → API languages). '
                    'Enabled: ${enabledLocales.map(AppLocales.label).join(', ')}.',
              ),
              const SizedBox(height: 20),
              if (business?.slug != null && business!.slug!.isNotEmpty)
                AppSectionCard(
                  title: l10n.apiPublicShopTitle,
                  subtitle: l10n.apiPublicShopSubtitle,
                  icon: Icons.storefront_outlined,
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          AppConstants.publicShopUrl(slug),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            color: colors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: () => openExternalUrl(
                          AppConstants.publicShopUrl(slug),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: Text(l10n.websiteOpenSite),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: AppConstants.publicShopUrl(slug),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.apiLinkCopied)),
                          );
                        },
                        icon: const Icon(Icons.link, size: 18),
                        label: Text(l10n.apiPublicShopCopy),
                      ),
                    ],
                  ),
                ),
              if (business?.slug != null && business!.slug!.isNotEmpty)
                const SizedBox(height: 20),
              const ApiKeysSection(),
              const SizedBox(height: 20),
              for (final e in endpoints) ...[
                _EndpointCard(endpoint: e),
                const SizedBox(height: 16),
              ],
              AppSectionCard(
                title: l10n.apiIntegrationGuideTitle,
                subtitle: l10n.apiIntegrationGuideSubtitle,
                icon: Icons.menu_book_outlined,
                padding: const EdgeInsets.all(20),
                trailing: IconButton(
                  tooltip: l10n.apiIntegrationInfo,
                  icon: Icon(Icons.info_outline_rounded, color: colors.accent),
                  onPressed: business == null
                      ? null
                      : () => _showIntegrationGuide(
                            context,
                            slug: slug,
                            enabledLocales: enabledLocales,
                            defaultLocale: defaultLang,
                          ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: business == null
                        ? null
                        : () => _showIntegrationGuide(
                              context,
                              slug: slug,
                              enabledLocales: enabledLocales,
                              defaultLocale: defaultLang,
                            ),
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: Text(l10n.apiIntegrationReadFull),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppSectionCard(
                title: l10n.apiLivePreview,
                subtitle: _loadingPreview
                    ? l10n.apiLivePreviewLoading
                    : (_previewSource ?? l10n.apiLivePreviewTap),
                icon: Icons.data_object_rounded,
                padding: const EdgeInsets.all(20),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l10n.apiIntegrationInfo,
                      icon: Icon(Icons.info_outline_rounded, color: colors.accent),
                      onPressed: business == null
                          ? null
                          : () => _showIntegrationGuide(
                                context,
                                slug: slug,
                                enabledLocales: enabledLocales,
                                defaultLocale: defaultLang,
                              ),
                    ),
                    IconButton(
                      tooltip: l10n.apiPreviewRefresh,
                      icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
                      onPressed: business == null || _loadingPreview
                          ? null
                          : () => _loadPreview(slug, lang: defaultLang),
                    ),
                    if (_loadingPreview)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.accent,
                          ),
                        ),
                      ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 160),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _loadingPreview && _previewJson == null
                      ? Center(
                          child: Text(
                            l10n.apiLivePreviewLoading,
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : _previewJson == null
                          ? Text(
                              business == null
                                  ? l10n.apiLivePreviewEmpty
                                  : l10n.apiLivePreviewTap,
                              style: GoogleFonts.inter(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            )
                          : SelectableText(
                              _previewJson!,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: const Color(0xFFE2E8F0),
                                height: 1.5,
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 24),
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.endpoint});

  final _Endpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.card(context),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusChip(
                label: endpoint.method,
                tone: endpoint.method == 'POST'
                    ? StatusChipTone.accent
                    : StatusChipTone.success,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  endpoint.path,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              if (endpoint.onPreview != null)
                TextButton.icon(
                  onPressed: endpoint.onPreview,
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Preview'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            endpoint.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    endpoint.url,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy URL',
                  icon: Icon(Icons.copy_rounded, size: 18, color: colors.textMuted),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: endpoint.url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copied')),
                    );
                  },
                ),
              ],
            ),
          ),
          if (endpoint.bodySample != null) ...[
            const SizedBox(height: 14),
            Text(
              'Request body',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                border: Border.all(color: colors.cardBorder),
              ),
              child: SelectableText(
                endpoint.bodySample!,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: const Color(0xFFE2E8F0),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Endpoint {
  const _Endpoint({
    required this.method,
    required this.path,
    required this.description,
    required this.url,
    this.onPreview,
    this.bodySample,
  });

  final String method;
  final String path;
  final String description;
  final String url;
  final VoidCallback? onPreview;
  final String? bodySample;
}
