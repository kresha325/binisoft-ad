/// How the business wants their public web presence.
enum WebsitePlan {
  /// MARKET template + site editor (self-service).
  simple,

  /// Custom site — contact Binisoft.
  professional,
}

extension WebsitePlanX on WebsitePlan {
  String get firestoreValue => name;

  static WebsitePlan? fromFirestore(String? value) {
    switch (value) {
      case 'simple':
        return WebsitePlan.simple;
      case 'professional':
        return WebsitePlan.professional;
      default:
        return null;
    }
  }
}
