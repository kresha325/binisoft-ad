// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get appTitle => 'Paneli i Biznesit';

  @override
  String get navDashboard => 'Paneli';

  @override
  String get navOrders => 'Porositë';

  @override
  String get navReports => 'Raportet';

  @override
  String get navBusinesses => 'Bizneset';

  @override
  String get navProducts => 'Produktet';

  @override
  String get navOffers => 'Ofertat';

  @override
  String get navCategories => 'Kategoritë';

  @override
  String get navCustomFields => 'Fushat e personalizuara';

  @override
  String get navApiDocs => 'Dokumentacioni API';

  @override
  String get navSettings => 'Cilësimet';

  @override
  String get navBilling => 'Faturimi';

  @override
  String get menuSignedInAs => 'I kyçur si';

  @override
  String get menuCreateBusiness => 'Krijo biznes të ri';

  @override
  String get menuLogOut => 'Dil';

  @override
  String get menuLanguage => 'Gjuha e aplikacionit';

  @override
  String get pageDashboardTitle => 'Paneli';

  @override
  String get pageDashboardSubtitle => 'Përmbledhje e katalogut të produkteve';

  @override
  String get pageBusinessesTitle => 'Bizneset';

  @override
  String get pageBusinessesSubtitle =>
      'Të gjitha bizneset — ndërro ose krijo të ri.';

  @override
  String get pageProductsTitle => 'Produktet';

  @override
  String get pageProductsSubtitle => 'Menaxho produktet e katalogut.';

  @override
  String get pageOffersTitle => 'Ofertat';

  @override
  String get pageOffersSubtitle =>
      'Promocione me % ose çmim shitjeje. Ofertat aktive vlejnë në API dhe porosi.';

  @override
  String get pageCategoriesTitle => 'Kategoritë';

  @override
  String get pageCategoriesSubtitle => 'Menaxho kategoritë e produkteve.';

  @override
  String get pageCustomFieldsTitle => 'Fushat e personalizuara';

  @override
  String get pageCustomFieldsSubtitle => 'Përcakto fushat për produktet.';

  @override
  String get pageApiDocsTitle => 'Dokumentacioni API';

  @override
  String get pageApiDocsSubtitle =>
      'Endpoint publike për katalogun (pa autentifikim).';

  @override
  String get pageSettingsTitle => 'Cilësimet';

  @override
  String get pageSettingsSubtitle => 'Profili, plani dhe pamja e panelit.';

  @override
  String get pageBillingTitle => 'Faturimi';

  @override
  String get pageBillingSubtitle => 'Historia e pagesave sipas muajit.';

  @override
  String get pageOrdersTitle => 'Porositë';

  @override
  String get pageOrdersSubtitle => 'Menaxho porositë nga dyqani.';

  @override
  String get pageReportsTitle => 'Raportet';

  @override
  String get pageReportsSubtitle => 'Analitika e shitjeve dhe porosive.';

  @override
  String get appearanceTitle => 'Pamja';

  @override
  String get appearanceSubtitle =>
      'Modaliteti i errët tregon sfondin. Modaliteti i ndritshëm përdor pamje glass pa imazh sfondi.';

  @override
  String get themeDark => 'Errët';

  @override
  String get themeLight => 'Ndritshëm';

  @override
  String get apiLanguagesTitle => 'Gjuhët e API';

  @override
  String get apiLanguagesSubtitle =>
      'Gjuhët për API publike të dyqanit (?lang=). Format tregojnë vetëm gjuhët e zgjedhura.';

  @override
  String get apiLanguagesSave => 'Ruaj gjuhët e API';

  @override
  String get apiLanguagesSaved => 'Gjuhët e API u ruajtën';

  @override
  String get apiLanguagesPickOne => 'Zgjidh të paktën një gjuhë për API';

  @override
  String get apiLanguagesDefault => 'Gjuha default e katalogut';

  @override
  String get apiLanguagesHint =>
      'Vetëm gjuha default është e detyrueshme kur shtoni produkte. Të tjerat janë opsionale.';

  @override
  String get localeSq => 'Shqip';

  @override
  String get localeEn => 'Anglisht';

  @override
  String get localeDe => 'Gjermanisht';

  @override
  String get saveChanges => 'Ruaj ndryshimet';

  @override
  String get changesSaved => 'Ndryshimet u ruajtën';

  @override
  String errorGeneric(String message) {
    return 'Gabim: $message';
  }

  @override
  String get cancel => 'Anulo';

  @override
  String get exportContinue => 'Eksporto';

  @override
  String get exportPickLanguageTitle => 'Gjuha e eksportit';

  @override
  String get exportPickLanguageSubtitle => 'Zgjidh gjuhën për dokumentin PDF.';

  @override
  String exportFailed(String message) {
    return 'Eksporti dështoi: $message';
  }

  @override
  String get downloadPdf => 'Shkarko PDF';

  @override
  String get sharePdf => 'Ndaj PDF';

  @override
  String get close => 'Mbyll';

  @override
  String get reportsExportTitle => 'Eksporto raportet';

  @override
  String get reportsExportSubtitle =>
      'Shkarko ose ndaj PDF për sot, javën, muajin ose vitin.';

  @override
  String get reportsThisWeek => 'Kjo javë';

  @override
  String get reportsThisWeekSubtitle => 'E hënë – sot';

  @override
  String get reportsRevenue => 'Të ardhurat';

  @override
  String get reportsOrders => 'Porositë';

  @override
  String get reportsPending => 'Në pritje';

  @override
  String get reportsRevenueHint => 'Pa të anuluarat';

  @override
  String get reportsOrderStatus => 'Statusi i porosive';

  @override
  String get reportsOrderStatusSubtitle =>
      'Në pritje, përfunduar dhe anuluar këtë javë';

  @override
  String get reportsProductsSold => 'Produktet e shitura';

  @override
  String get reportsProductsSoldSubtitle =>
      'Nga porositë aktive dhe të përfunduara';

  @override
  String get reportsOrdersThisWeek => 'Porositë këtë javë';

  @override
  String get pageReportsSubtitleLong =>
      'Eksporto PDF dhe shiko shitjet për periudhën aktuale.';

  @override
  String get loadingInvoices => 'Duke ngarkuar faturat…';

  @override
  String get noInvoicesYet => 'Ende pa fatura';

  @override
  String get noInvoicesHint =>
      'Faturat shfaqen pas regjistrimit ose faturimit mujor.';

  @override
  String get invoiceTitle => 'Faturë';

  @override
  String get invoiceAmount => 'Shuma';

  @override
  String get invoiceType => 'Lloji';

  @override
  String get invoiceTypeSubscription => 'Abonim';

  @override
  String get invoiceTypeMonthly => 'Pagesë mujore';

  @override
  String get invoicePlan => 'Plani';

  @override
  String get invoicePaid => 'Paguar';

  @override
  String get invoiceMethod => 'Metoda';

  @override
  String get invoiceDetails => 'Detaje';

  @override
  String invoicePlanProducts(String plan, int count) {
    return '$plan · deri në $count produkte';
  }

  @override
  String get orderStatusPending => 'Në pritje';

  @override
  String get orderStatusCompleted => 'Përfunduar';

  @override
  String get orderStatusCancelled => 'Anuluar';

  @override
  String get periodDaily => 'Ditor';

  @override
  String get periodWeekly => 'Javor';

  @override
  String get periodMonthly => 'Mujor';

  @override
  String get periodYearly => 'Vjetor';

  @override
  String get ordersTodayTitle => 'Porositë sot';

  @override
  String get ordersTodaySubtitle => 'Porositë e marra sot nga dyqani online.';

  @override
  String get ordersLatestTitle => 'Porosia më e fundit';

  @override
  String get ordersLatestSubtitle => 'Porosia më e re nga dyqani juaj.';

  @override
  String get ordersSearchHint => 'Kërko # porosie, klient, produkt…';

  @override
  String get tableOrder => 'Porosia';

  @override
  String get tableCustomer => 'Klienti';

  @override
  String get tableProduct => 'Produkti';

  @override
  String get tableQty => 'Sasia';

  @override
  String get tableTotal => 'Totali';

  @override
  String get tableStatus => 'Statusi';

  @override
  String get tableDate => 'Data';

  @override
  String get ordersEmptyToday => 'Ende pa porosi sot.';

  @override
  String get ordersEmptyNone => 'Ende pa porosi.';

  @override
  String get ordersEmptyConnect =>
      'Ende pa porosi. Lidh dyqanin me POST /orders (API Docs).';

  @override
  String get orderNoPhone => 'Pa numër telefoni';

  @override
  String orderDialerFailed(String phone) {
    return 'Nuk u hap thirrësi për $phone';
  }

  @override
  String get orderDetailCustomer => 'Klienti';

  @override
  String get orderDetailProducts => 'Produktet';

  @override
  String get orderDetailTotal => 'Totali';

  @override
  String get orderConfirm => 'Konfirmo porosinë';

  @override
  String get recentOrdersTitle => 'Porositë e fundit';

  @override
  String get recentOrdersSubtitle => 'Produktet e porositura nga dyqani';

  @override
  String get seeAll => 'Shiko të gjitha';

  @override
  String get viewAllOrders => 'Shiko të gjitha porositë';

  @override
  String get dashboardOrdersToday => 'Porositë sot';

  @override
  String get dashboardPendingOrders => 'Porosi në pritje';

  @override
  String get dashboardSalesWeek => 'Shitjet këtë javë';

  @override
  String get dashboardTotalProducts => 'Produkte gjithsej';

  @override
  String get dashboardActiveProducts => 'Produkte aktive';

  @override
  String get dashboardCategories => 'Kategoritë';

  @override
  String get topProductsTitle => 'Produktet kryesore këtë javë';

  @override
  String get topProductsSubtitle =>
      'Sasia e shitur dhe të ardhurat për produkt';

  @override
  String get topProductsColumnProduct => 'PRODUKTI';

  @override
  String get topProductsColumnQty => 'SASIA';

  @override
  String get topProductsColumnRevenue => 'TË ARDHURAT';

  @override
  String get productsByCategoryTitle => 'Produktet sipas kategorisë';

  @override
  String get addCategory => 'Shto kategori';

  @override
  String get addProduct => 'Shto produkt';

  @override
  String get addField => 'Shto fushë';

  @override
  String get searchProducts => 'Kërko produkte…';

  @override
  String get filterAllCategories => 'Të gjitha kategoritë';

  @override
  String get filterAll => 'Të gjitha';

  @override
  String get productStatusActive => 'Aktiv';

  @override
  String get productStatusDraft => 'Draft';

  @override
  String get productStatusArchived => 'Arkivuar';

  @override
  String get tableImage => 'Imazhi';

  @override
  String get tableName => 'Emri';

  @override
  String get tableCategory => 'Kategoria';

  @override
  String get tablePrice => 'Çmimi';

  @override
  String get tableActions => 'Veprimet';

  @override
  String get tableDescription => 'Përshkrimi';

  @override
  String get tableLabel => 'Etiketa';

  @override
  String get tableKey => 'Emri (çelësi)';

  @override
  String get tableType => 'Lloji';

  @override
  String get tableRequired => 'E detyrueshme';

  @override
  String get productsEmpty => 'Nuk u gjetën produkte.';

  @override
  String get categoriesEmpty => 'Nuk u gjetën kategori.';

  @override
  String get customFieldsAll => 'Të gjitha fushat';

  @override
  String get customFieldsEmpty => 'Nuk ka fusha të personalizuara.';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusInactive => 'Joaktiv';

  @override
  String get yes => 'Po';

  @override
  String get no => 'Jo';

  @override
  String get settingsActiveBusinessTitle => 'Profili aktiv i biznesit';

  @override
  String get settingsActiveBusinessSubtitle =>
      'Përditëso detajet publike të biznesit.';

  @override
  String get settingsBusinessName => 'Emri i biznesit';

  @override
  String get settingsDescription => 'Përshkrimi';

  @override
  String get settingsDescriptionHint => 'Përshkrim i shkurtër i biznesit';

  @override
  String get settingsLogoUrl => 'URL e logos';

  @override
  String get settingsOrderPhone => 'Telefoni i porosive (WhatsApp)';

  @override
  String get subscriptionPlanTitle => 'Plani i abonimit';

  @override
  String get changePlan => 'Ndrysho planin';

  @override
  String get settingsOrderPhoneNote =>
      'Përdoret kur dyqani online dërgon porosi përmes WhatsApp.';

  @override
  String get productsByCategoryEmpty =>
      'Ende pa produkte. Shtoni nga faqja Produktet.';

  @override
  String get offerAddTitle => 'Shto ofertë';

  @override
  String get offerEditTitle => 'Ndrysho ofertën';

  @override
  String get offerSave => 'Ruaj ofertën';

  @override
  String get offerActive => 'Aktive';

  @override
  String offerDurationLabel(int days) {
    return 'Kohëzgjatja: $days ditë';
  }

  @override
  String get offerProductsLabel => 'Produktet në ofertë';

  @override
  String get offerNoProducts =>
      'Nuk ka produkte aktive. Shtoni produkte së pari.';

  @override
  String get offerPickProducts => 'Zgjidhni të paktën një produkt.';

  @override
  String get offerModePercent => '% zbritje';

  @override
  String get offerModeSalePrice => 'Çmim shitjeje';

  @override
  String get offerPercentLabel => 'Përqindja e zbritjes';

  @override
  String get offerSalePriceLabel => 'Çmimi i shitjes (EUR)';

  @override
  String get offerInvalidPercent =>
      'Vendosni përqindje zbritjeje më të madhe se 0.';

  @override
  String get offerInvalidPrice => 'Vendosni një çmim shitjeje të vlefshëm.';

  @override
  String get offersEmpty => 'Ende pa oferta.';

  @override
  String get offerColumnProducts => 'Produkte';

  @override
  String get offerColumnDiscount => 'Zbritja';

  @override
  String get offerColumnPeriod => 'Periudha';

  @override
  String get offerStatusLive => 'Aktive';

  @override
  String get offerStatusScheduled => 'E planifikuar';

  @override
  String get offerStatusExpired => 'Skaduar';

  @override
  String get searchOffers => 'Kërko oferta…';

  @override
  String get offerSectionDetails => 'Detajet kryesore';

  @override
  String get offerSectionDuration => 'Kohëzgjatja & dukshmëria';

  @override
  String get offerRenewHint =>
      'Ruajtja fillon periudhë të re nga sot (oferta ka skaduar).';

  @override
  String get offerSaved => 'Oferta u ruajt';

  @override
  String get offerUpdated => 'Oferta u përditësua';

  @override
  String get offerDeleted => 'Oferta u fshi';

  @override
  String get offerDeleteTitle => 'Fshi ofertën?';

  @override
  String offerDeleteMessage(String title) {
    return 'Fshi \"$title\"?';
  }

  @override
  String get offerDeleteConfirm => 'Fshi';

  @override
  String offerSummaryPercent(double percent) {
    return '$percent% zbritje';
  }

  @override
  String offerSummarySalePrice(double price) {
    return '€$price';
  }

  @override
  String get apiLivePreview => 'Parapamje live';

  @override
  String get apiLivePreviewTap => 'Shtyp Preview te endpoint-i products';

  @override
  String get apiLivePreviewLoading => 'Duke ngarkuar parapamjen…';

  @override
  String get apiLivePreviewEmpty => 'Zgjidh një biznes për parapamje.';

  @override
  String get apiPreviewRefresh => 'Rifresko parapamjen';

  @override
  String get apiIntegrationInfo => 'Udhëzues integrimi';

  @override
  String get apiIntegrationInfoTitle => 'Integrimi i dyqanit web';

  @override
  String get apiIntegrationGuideTitle => 'Udhëzues integrimi web';

  @override
  String get apiIntegrationGuideSubtitle =>
      'Si ta lidhësh menu-n ose faqen e shitjes me këtë API.';

  @override
  String get apiIntegrationReadFull => 'Lexo udhëzuesin e plotë';
}
