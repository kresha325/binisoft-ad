class AppConstants {
  static const String projectId = 'jon-sport';
  static const int defaultPageSize = 20;

  /// Unified Firebase Hosting (same origin for /admin + /shop).
  static const String platformOrigin = 'https://jon-sport.web.app';

  /// Cloud Function `publicApi` — public catalog JSON (direct URL).
  static const String publicApiBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net/publicApi';

  /// Same-origin public API via Hosting rewrite (`/api/public/**` → publicApi).
  static const String publicApiSameOriginBaseUrl = '$platformOrigin';

  /// Shop app catalog (`shopApi` / `/api/shop/*`) — same handler as [publicApiBaseUrl].
  static const String shopApiBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net/shopApi';

  /// Global marketplace home (`/shop` on platform domain).
  static const String marketplaceHomeUrl = '$platformOrigin/shop/';

  /// Multi-tenant public storefront (path per business slug under /shop).
  static const String publicShopBaseUrl = '$platformOrigin/shop';

  static String publicShopUrl(String slug) => '$publicShopBaseUrl/$slug';

  /// Legacy dedicated shop Hosting site (fallback).
  static const String firebaseShopBaseUrl = 'https://jon-sport-shop.web.app';

  /// Marketing site (static HTML at platform root).
  static const String marketingWebUrl = platformOrigin;

  /// Flutter admin app (`/admin` on platform domain).
  static const String dashboardWebUrl = '$platformOrigin/admin';

  static const String dashboardWebOrigin = platformOrigin;

  /// Play Store / App Store privacy policy.
  static const String privacyPolicyUrl = '$platformOrigin/privacy.html';
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
