class AppConstants {
  static const String projectId = 'jon-sport';
  static const int defaultPageSize = 20;

  /// Cloud Function `publicApi` — public catalog JSON.
  static const String publicApiBaseUrl =
      'https://us-central1-jon-sport.cloudfunctions.net/publicApi';

  /// Admin dashboard (GitHub Pages only).
  static const String dashboardWebUrl =
      'https://kresha325.github.io/binisoft-ad';

  static const String dashboardWebOrigin = 'https://kresha325.github.io';
}

class FirestoreCollections {
  static const String businesses = 'businesses';
  static const String users = 'users';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String offers = 'offers';
  static const String productVariants = 'productVariants';
  static const String attributes = 'attributes';
  static const String attributeValues = 'attributeValues';
  static const String media = 'media';
  static const String apiKeys = 'apiKeys';
  static const String orders = 'orders';
  static const String settings = 'settings';
}

class StoragePaths {
  static String businessRoot(String businessId) => 'businesses/$businessId';
  static String productMedia(String businessId, String productId) =>
      '${businessRoot(businessId)}/products/$productId';
}
