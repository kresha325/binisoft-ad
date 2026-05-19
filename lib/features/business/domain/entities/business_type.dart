import 'package:business_dashboard/l10n/app_localizations.dart';

/// Fixed business categories — creator picks one at store creation (no default).
enum BusinessType {
  retail,
  fashion,
  electronics,
  it,
  digitalAgency,
  construction,
  realEstate,
  photography,
  events,
  logistics,
  agriculture,
  grocery,
  bakery,
  wholesale,
  restaurant,
  cafe,
  fastFood,
  pharmacy,
  petShop,
  services,
  salon,
  spa,
  clinic,
  automotive,
  fitness,
  education,
  professional,
  homeServices,
  hotel,
  other;

  String get firestoreValue => name;

  /// Display order in the create-store dropdown.
  static const List<BusinessType> choices = [
    retail,
    fashion,
    electronics,
    it,
    digitalAgency,
    construction,
    realEstate,
    photography,
    events,
    logistics,
    agriculture,
    grocery,
    bakery,
    wholesale,
    restaurant,
    cafe,
    fastFood,
    pharmacy,
    petShop,
    services,
    salon,
    spa,
    clinic,
    automotive,
    fitness,
    education,
    professional,
    homeServices,
    hotel,
    other,
  ];

  static BusinessType? fromFirestore(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final t in BusinessType.values) {
      if (t.firestoreValue == raw) return t;
    }
    return null;
  }

  String label(AppLocalizations l10n) => switch (this) {
        BusinessType.retail => l10n.businessTypeRetail,
        BusinessType.fashion => l10n.businessTypeFashion,
        BusinessType.electronics => l10n.businessTypeElectronics,
        BusinessType.it => l10n.businessTypeIt,
        BusinessType.digitalAgency => l10n.businessTypeDigitalAgency,
        BusinessType.construction => l10n.businessTypeConstruction,
        BusinessType.realEstate => l10n.businessTypeRealEstate,
        BusinessType.photography => l10n.businessTypePhotography,
        BusinessType.events => l10n.businessTypeEvents,
        BusinessType.logistics => l10n.businessTypeLogistics,
        BusinessType.agriculture => l10n.businessTypeAgriculture,
        BusinessType.grocery => l10n.businessTypeGrocery,
        BusinessType.bakery => l10n.businessTypeBakery,
        BusinessType.wholesale => l10n.businessTypeWholesale,
        BusinessType.restaurant => l10n.businessTypeRestaurant,
        BusinessType.cafe => l10n.businessTypeCafe,
        BusinessType.fastFood => l10n.businessTypeFastFood,
        BusinessType.pharmacy => l10n.businessTypePharmacy,
        BusinessType.petShop => l10n.businessTypePetShop,
        BusinessType.services => l10n.businessTypeServices,
        BusinessType.salon => l10n.businessTypeSalon,
        BusinessType.spa => l10n.businessTypeSpa,
        BusinessType.clinic => l10n.businessTypeClinic,
        BusinessType.automotive => l10n.businessTypeAutomotive,
        BusinessType.fitness => l10n.businessTypeFitness,
        BusinessType.education => l10n.businessTypeEducation,
        BusinessType.professional => l10n.businessTypeProfessional,
        BusinessType.homeServices => l10n.businessTypeHomeServices,
        BusinessType.hotel => l10n.businessTypeHotel,
        BusinessType.other => l10n.businessTypeOther,
      };
}
