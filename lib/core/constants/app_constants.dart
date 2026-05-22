class AppConstants {
  static const String projectId = 'jon-sport';
  static const int defaultPageSize = 20;

  /// Cloud Function `publicApi` — public catalog JSON.
  static const String publicApiBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net/publicApi';

  /// Shop app catalog (`shopApi` / `/api/shop/*`) — same handler as [publicApiBaseUrl].
  static const String shopApiBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net/shopApi';

  /// Global marketplace home (GitHub Pages).
  static const String marketplaceHomeUrl =
      'https://kresha325.github.io/Binisoft-marketplace/';

  /// Multi-tenant public storefront (path per business slug).
  static const String publicShopBaseUrl =
      'https://kresha325.github.io/Binisoft-marketplace';

  static String publicShopUrl(String slug) => '$publicShopBaseUrl/$slug';

  /// Legacy Firebase Hosting shop (optional fallback).
  static const String firebaseShopBaseUrl = 'https://jon-sport-shop.web.app';

  /// Marketing site (static HTML, fast on mobile).
  static const String marketingWebUrl =
      'https://kresha325.github.io/binisoft-ad';

  /// Flutter admin app (GitHub Pages /app/ — heavy; use after login CTA).
  static const String dashboardWebUrl =
      'https://kresha325.github.io/binisoft-ad/app';

  static const String dashboardWebOrigin = 'https://kresha325.github.io';

  /// Play Store / App Store privacy policy (static marketing page).
  static const String privacyPolicyUrl =
      'https://kresha325.github.io/binisoft-ad/privacy.html';
}

class FirestoreCollections {
  static const String businesses = 'businesses';
  static const String users = 'users';
  static const String categories = 'categories';
  static const String services = 'services';
  static const String products = 'products';
  static const String offers = 'offers';
  static const String contests = 'contests';
  static const String jobOpenings = 'jobOpenings';
  static const String productVariants = 'productVariants';
  static const String attributes = 'attributes';
  static const String attributeValues = 'attributeValues';
  static const String media = 'media';
  static const String apiKeys = 'apiKeys';
  static const String orders = 'orders';
  static const String appointments = 'appointments';
  static const String employees = 'employees';
  static const String settings = 'settings';
  static const String members = 'members';
  static const String invites = 'invites';
}

class CloudFunctionUrls {
  CloudFunctionUrls._();

  static const String _base = 'https://us-central1-jon-sport.cloudfunctions.net';

  static String inviteStaff = '$_base/inviteStaffHttp';
  static String removeStaff = '$_base/removeStaffHttp';
  static String acceptInvite = '$_base/acceptInviteHttp';
}

class StoragePaths {
  static String businessRoot(String businessId) => 'businesses/$businessId';
  static String productMedia(String businessId, String productId) =>
      '${businessRoot(businessId)}/products/$productId';
}
