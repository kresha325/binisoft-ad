import '../../../core/constants/app_constants.dart';
import '../../../core/i18n/app_locales.dart';

/// Textual guide for connecting a public web shop to Binisoft Public API.
abstract final class WebIntegrationGuide {
  static String forLocale(
    String languageCode, {
    required String slug,
    required List<String> enabledLocales,
    required String defaultLocale,
  }) {
    final lang = AppLocales.normalize(languageCode) ?? 'en';
    final localesList = enabledLocales.map(AppLocales.label).join(', ');
    final base = AppConstants.publicApiBaseUrl;
    final catalogUrl = '$base/api/public/$slug/products?lang=$defaultLocale';
    final offersUrl = '$base/api/public/$slug/offers?lang=$defaultLocale';
    final ordersUrl = '$base/api/public/$slug/orders';

    return switch (lang) {
      'sq' => _sq(slug, localesList, defaultLocale, catalogUrl, offersUrl, ordersUrl),
      'de' => _de(slug, localesList, defaultLocale, catalogUrl, offersUrl, ordersUrl),
      _ => _en(slug, localesList, defaultLocale, catalogUrl, offersUrl, ordersUrl),
    };
  }

  static String _en(
    String slug,
    String localesList,
    String defaultLocale,
    String catalogUrl,
    String offersUrl,
    String ordersUrl,
  ) =>
      '''
Binisoft Public API — Web shop integration

Base URL
${AppConstants.publicApiBaseUrl}

Your business slug: $slug
API languages enabled: $localesList (default: ${AppLocales.label(defaultLocale)})

1) Read the catalog (no API key)
   GET $catalogUrl
   Returns: meta, business, categories, customFields, products.
   Each product includes price, optional onOffer, originalPrice, offerId when a promotion applies.
   Pass ?lang=sq|en|de on every GET to match your site language.

2) Read active offers (optional, no API key)
   GET $offersUrl
   Returns active promotions with productId, originalPrice, salePrice.
   You decide how to show badges, banners, or strikethrough prices in your UI.

3) Display products on your site
   • Fetch products once and cache (re-fetch when user changes language).
   • Map categoryIds to category names from the categories array.
   • Use product.imageUrls[0] for thumbnails.
   • Show attributeData / attributes for filters (size, color, etc.).

4) Submit orders (API key required)
   POST $ordersUrl
   Header: Authorization: Bearer YOUR_API_KEY
   Body example:
   {
     "customer": { "name": "...", "phone": "+383...", "notes": "..." },
     "lines": [ { "productId": "FIRESTORE_PRODUCT_ID", "quantity": 2 } ],
     "channel": "whatsapp"
   }
   Prices are calculated server-side (including active offers). Do not send prices from the browser.

5) API keys
   Create keys in this app: API Docs → API Keys. One key per website or environment.

6) CORS & hosting
   The Cloud Function allows browser requests. Call the API from your frontend or via your own backend proxy if you prefer to hide keys (recommended for order POST only).

7) Typical flow
   Home → GET products → product page → add to cart (local) → checkout → POST /orders → show WhatsApp link from response (messageText / whatsAppUrl).

8) Deploy
   After backend changes: firebase deploy --project=jon-sport --only functions:publicApi,firestore:rules
''';

  static String _sq(
    String slug,
    String localesList,
    String defaultLocale,
    String catalogUrl,
    String offersUrl,
    String ordersUrl,
  ) =>
      '''
Binisoft Public API — Integrimi i dyqanit web

URL bazë
${AppConstants.publicApiBaseUrl}

Slug i biznesit: $slug
Gjuhët e API: $localesList (default: ${AppLocales.label(defaultLocale)})

1) Lexo katalogun (pa API key)
   GET $catalogUrl
   Kthen: meta, business, categories, customFields, products.
   Çdo produkt ka price; nëse ka ofertë aktive: onOffer, originalPrice, offerId.
   Përdor ?lang=sq|en|de në çdo GET sipas gjuhës së faqes.

2) Lexo ofertat aktive (opsionale, pa API key)
   GET $offersUrl
   Kthen promocionet me productId, originalPrice, salePrice.
   Ti vendos si t’i shfaqësh në UI (badge, banner, çmim i vjetër).

3) Shfaq produktet në web
   • Merr produktet dhe ruaji në cache (rifresko kur ndryshon gjuha).
   • Lidh categoryIds me emrat nga categories.
   • Përdor imageUrls për foto.
   • Përdor attributes për filtra (madhësi, ngjyrë, etj.).

4) Dërgo porositë (kërkon API key)
   POST $ordersUrl
   Header: Authorization: Bearer API_KEY_JUAJ
   Trupi shembull:
   {
     "customer": { "name": "...", "phone": "+383...", "notes": "..." },
     "lines": [ { "productId": "ID_PRODUKTIT_NGA_FIRESTORE", "quantity": 2 } ],
     "channel": "whatsapp"
   }
   Çmimet llogariten në server (përfshirë ofertat). Mos dërgo çmime nga browser.

5) API keys
   Krijoji këtu: API Docs → API Keys. Një çelës për çdo faqe ose mjedis.

6) CORS & hosting
   Cloud Function lejon kërkesa nga browser. Mund ta thërrasësh direkt nga frontend ose përmes backend-it tënd (rekomandohet për POST porosi).

7) Rrjedha tipike
   Faqja kryesore → GET products → faqja produktit → shporta (lokale) → checkout → POST /orders → shfaq linkun WhatsApp nga përgjigjja.

8) Deploy
   Pas ndryshimeve: firebase deploy --project=jon-sport --only functions:publicApi,firestore:rules
''';

  static String _de(
    String slug,
    String localesList,
    String defaultLocale,
    String catalogUrl,
    String offersUrl,
    String ordersUrl,
  ) =>
      '''
Binisoft Public API — Webshop-Integration

Basis-URL
${AppConstants.publicApiBaseUrl}

Ihr Slug: $slug
API-Sprachen: $localesList (Standard: ${AppLocales.label(defaultLocale)})

1) Katalog lesen (ohne API-Key)
   GET $catalogUrl
   Antwort: meta, business, categories, customFields, products.
   Produkte enthalten price; bei aktiven Angeboten: onOffer, originalPrice, offerId.
   ?lang=sq|en|de bei jedem GET verwenden.

2) Aktive Angebote (optional, ohne API-Key)
   GET $offersUrl
   Aktive Aktionen mit productId, originalPrice, salePrice.
   Darstellung (Badge, Banner) liegt bei Ihnen.

3) Produkte anzeigen
   • Produkte laden und cachen (bei Sprachwechsel neu laden).
   • categoryIds den Kategorien zuordnen.
   • imageUrls für Bilder nutzen.
   • attributes für Filter verwenden.

4) Bestellungen senden (API-Key erforderlich)
   POST $ordersUrl
   Header: Authorization: Bearer IHR_API_KEY
   Preise werden serverseitig berechnet (inkl. Angebote). Keine Preise vom Browser senden.

5) API-Keys
   Unter API Docs → API Keys erstellen.

6) CORS
   Browser-Aufrufe sind erlaubt. Für POST /orders Backend-Proxy empfohlen.

7) Ablauf
   Start → GET products → Produktseite → Warenkorb → POST /orders → WhatsApp-Link aus Antwort.

8) Deploy
   firebase deploy --project=jon-sport --only functions:publicApi,firestore:rules
''';
}
