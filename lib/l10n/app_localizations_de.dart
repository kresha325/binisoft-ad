// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Business Dashboard';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Bestellungen';

  @override
  String get navReports => 'Berichte';

  @override
  String get navBusinesses => 'Unternehmen';

  @override
  String get navProducts => 'Produkte';

  @override
  String get navOffers => 'Angebote';

  @override
  String get navCategories => 'Kategorien';

  @override
  String get navCustomFields => 'Benutzerdefinierte Felder';

  @override
  String get navApiDocs => 'API-Dokumentation';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navBilling => 'Abrechnung';

  @override
  String get menuSignedInAs => 'Angemeldet als';

  @override
  String get menuCreateBusiness => 'Neues Unternehmen';

  @override
  String get menuLogOut => 'Abmelden';

  @override
  String get menuLanguage => 'App-Sprache';

  @override
  String get pageDashboardTitle => 'Dashboard';

  @override
  String get pageDashboardSubtitle => 'Überblick über Ihren Produktkatalog';

  @override
  String get pageBusinessesTitle => 'Unternehmen';

  @override
  String get pageBusinessesSubtitle =>
      'Alle Unternehmen — wechseln oder neu anlegen.';

  @override
  String get pageProductsTitle => 'Produkte';

  @override
  String get pageProductsSubtitle => 'Katalogeinträge verwalten.';

  @override
  String get pageOffersTitle => 'Angebote';

  @override
  String get pageOffersSubtitle =>
      'Aktionen mit % oder Aktionspreis. Aktive Angebote gelten in API und Bestellungen.';

  @override
  String get pageCategoriesTitle => 'Kategorien';

  @override
  String get pageCategoriesSubtitle => 'Produktkategorien verwalten.';

  @override
  String get pageCustomFieldsTitle => 'Benutzerdefinierte Felder';

  @override
  String get pageCustomFieldsSubtitle => 'Schema für Ihre Produkte definieren.';

  @override
  String get pageApiDocsTitle => 'API-Dokumentation';

  @override
  String get pageApiDocsSubtitle =>
      'Öffentliche Katalog-Endpunkte (ohne Auth).';

  @override
  String get pageSettingsTitle => 'Einstellungen';

  @override
  String get pageSettingsSubtitle =>
      'Profil, Plan und Dashboard-Erscheinungsbild.';

  @override
  String get pageBillingTitle => 'Abrechnung';

  @override
  String get pageBillingSubtitle => 'Zahlungshistorie nach Monat.';

  @override
  String get pageOrdersTitle => 'Bestellungen';

  @override
  String get pageOrdersSubtitle => 'Eingehende Shop-Bestellungen verwalten.';

  @override
  String get pageReportsTitle => 'Berichte';

  @override
  String get pageReportsSubtitle => 'Verkaufs- und Bestellanalysen.';

  @override
  String get appearanceTitle => 'Erscheinungsbild';

  @override
  String get appearanceSubtitle =>
      'Dunkelmodus zeigt Ihr Hintergrundbild. Hellmodus nutzt Glass-Look ohne Hintergrund.';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get apiLanguagesTitle => 'API-Sprachen';

  @override
  String get apiLanguagesSubtitle =>
      'Sprachen für die öffentliche Shop-API (?lang=). Formulare zeigen nur gewählte Sprachen.';

  @override
  String get apiLanguagesSave => 'API-Sprachen speichern';

  @override
  String get apiLanguagesSaved => 'API-Sprachen gespeichert';

  @override
  String get apiLanguagesPickOne =>
      'Mindestens eine Sprache für die API wählen';

  @override
  String get apiLanguagesDefault => 'Standard-Katalogsprache';

  @override
  String get apiLanguagesHint =>
      'Nur die Standardsprache ist beim Anlegen von Produkten Pflicht.';

  @override
  String get localeSq => 'Albanisch';

  @override
  String get localeEn => 'Englisch';

  @override
  String get localeDe => 'Deutsch';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get changesSaved => 'Änderungen gespeichert';

  @override
  String errorGeneric(String message) {
    return 'Fehler: $message';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get exportContinue => 'Exportieren';

  @override
  String get exportPickLanguageTitle => 'Exportsprache';

  @override
  String get exportPickLanguageSubtitle =>
      'Sprache für das PDF-Dokument wählen.';

  @override
  String exportFailed(String message) {
    return 'Export fehlgeschlagen: $message';
  }

  @override
  String get downloadPdf => 'PDF herunterladen';

  @override
  String get sharePdf => 'PDF teilen';

  @override
  String get close => 'Schließen';

  @override
  String get reportsExportTitle => 'Berichte exportieren';

  @override
  String get reportsExportSubtitle =>
      'PDF für heute, Woche, Monat oder Jahr laden oder teilen.';

  @override
  String get reportsThisWeek => 'Diese Woche';

  @override
  String get reportsThisWeekSubtitle => 'Montag – heute';

  @override
  String get reportsRevenue => 'Umsatz';

  @override
  String get reportsOrders => 'Bestellungen';

  @override
  String get reportsPending => 'Ausstehend';

  @override
  String get reportsRevenueHint => 'Ohne Stornierungen';

  @override
  String get reportsOrderStatus => 'Bestellstatus';

  @override
  String get reportsOrderStatusSubtitle =>
      'Ausstehend, abgeschlossen und storniert diese Woche';

  @override
  String get reportsProductsSold => 'Verkaufte Produkte';

  @override
  String get reportsProductsSoldSubtitle =>
      'Aus aktiven und abgeschlossenen Bestellungen';

  @override
  String get reportsOrdersThisWeek => 'Bestellungen diese Woche';

  @override
  String get pageReportsSubtitleLong =>
      'PDFs exportieren und Verkäufe für den aktuellen Zeitraum anzeigen.';

  @override
  String get loadingInvoices => 'Rechnungen werden geladen…';

  @override
  String get noInvoicesYet => 'Noch keine Rechnungen';

  @override
  String get noInvoicesHint =>
      'Rechnungen erscheinen nach Registrierung oder monatlicher Abrechnung.';

  @override
  String get invoiceTitle => 'Rechnung';

  @override
  String get invoiceAmount => 'Betrag';

  @override
  String get invoiceType => 'Typ';

  @override
  String get invoiceTypeSubscription => 'Abonnement';

  @override
  String get invoiceTypeMonthly => 'Monatliche Zahlung';

  @override
  String get invoicePlan => 'Tarif';

  @override
  String get invoicePaid => 'Bezahlt';

  @override
  String get invoiceMethod => 'Methode';

  @override
  String get invoiceDetails => 'Details';

  @override
  String invoicePlanProducts(String plan, int count) {
    return '$plan · bis zu $count Produkte';
  }

  @override
  String get orderStatusPending => 'Ausstehend';

  @override
  String get orderStatusCompleted => 'Abgeschlossen';

  @override
  String get orderStatusCancelled => 'Storniert';

  @override
  String get periodDaily => 'Täglich';

  @override
  String get periodWeekly => 'Wöchentlich';

  @override
  String get periodMonthly => 'Monatlich';

  @override
  String get periodYearly => 'Jährlich';

  @override
  String get ordersTodayTitle => 'Bestellungen heute';

  @override
  String get ordersTodaySubtitle => 'Heute eingegangene Online-Bestellungen.';

  @override
  String get ordersLatestTitle => 'Letzte Bestellung';

  @override
  String get ordersLatestSubtitle => 'Die neueste Bestellung aus Ihrem Shop.';

  @override
  String get ordersSearchHint => 'Bestellnr., Kunde, Produkt suchen…';

  @override
  String get tableOrder => 'Bestellung';

  @override
  String get tableCustomer => 'Kunde';

  @override
  String get tableProduct => 'Produkt';

  @override
  String get tableQty => 'Menge';

  @override
  String get tableTotal => 'Summe';

  @override
  String get tableStatus => 'Status';

  @override
  String get tableDate => 'Datum';

  @override
  String get ordersEmptyToday => 'Heute noch keine Bestellungen.';

  @override
  String get ordersEmptyNone => 'Noch keine Bestellungen.';

  @override
  String get ordersEmptyConnect =>
      'Noch keine Bestellungen. Shop mit POST /orders verbinden (API-Docs).';

  @override
  String get orderNoPhone => 'Keine Telefonnummer';

  @override
  String orderDialerFailed(String phone) {
    return 'Telefon-App konnte nicht geöffnet werden: $phone';
  }

  @override
  String get orderDetailCustomer => 'Kunde';

  @override
  String get orderDetailProducts => 'Produkte';

  @override
  String get orderDetailTotal => 'Gesamt';

  @override
  String get orderConfirm => 'Bestellung bestätigen';

  @override
  String get recentOrdersTitle => 'Letzte Bestellungen';

  @override
  String get recentOrdersSubtitle => 'Bestellte Produkte aus Ihrem Shop';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get viewAllOrders => 'Alle Bestellungen';

  @override
  String get dashboardOrdersToday => 'Bestellungen heute';

  @override
  String get dashboardPendingOrders => 'Offene Bestellungen';

  @override
  String get dashboardSalesWeek => 'Umsatz diese Woche';

  @override
  String get dashboardTotalProducts => 'Produkte gesamt';

  @override
  String get dashboardActiveProducts => 'Aktive Produkte';

  @override
  String get dashboardCategories => 'Kategorien';

  @override
  String get topProductsTitle => 'Top-Produkte diese Woche';

  @override
  String get topProductsSubtitle => 'Verkaufte Menge und Umsatz pro Produkt';

  @override
  String get topProductsColumnProduct => 'PRODUKT';

  @override
  String get topProductsColumnQty => 'MENGE';

  @override
  String get topProductsColumnRevenue => 'UMSATZ';

  @override
  String get productsByCategoryTitle => 'Produkte nach Kategorie';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get addProduct => 'Produkt hinzufügen';

  @override
  String get addField => 'Feld hinzufügen';

  @override
  String get searchProducts => 'Produkte suchen…';

  @override
  String get filterAllCategories => 'Alle Kategorien';

  @override
  String get filterAll => 'Alle';

  @override
  String get productStatusActive => 'Aktiv';

  @override
  String get productStatusDraft => 'Entwurf';

  @override
  String get productStatusArchived => 'Archiviert';

  @override
  String get tableImage => 'Bild';

  @override
  String get tableName => 'Name';

  @override
  String get tableCategory => 'Kategorie';

  @override
  String get tablePrice => 'Preis';

  @override
  String get tableActions => 'Aktionen';

  @override
  String get tableDescription => 'Beschreibung';

  @override
  String get tableLabel => 'Bezeichnung';

  @override
  String get tableKey => 'Name (Schlüssel)';

  @override
  String get tableType => 'Typ';

  @override
  String get tableRequired => 'Pflicht';

  @override
  String get productsEmpty => 'Keine Produkte gefunden.';

  @override
  String get categoriesEmpty => 'Keine Kategorien gefunden.';

  @override
  String get customFieldsAll => 'Alle Felder';

  @override
  String get customFieldsEmpty => 'Keine benutzerdefinierten Felder.';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusInactive => 'Inaktiv';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get settingsActiveBusinessTitle => 'Aktives Geschäftsprofil';

  @override
  String get settingsActiveBusinessSubtitle =>
      'Öffentliche Geschäftsdaten aktualisieren.';

  @override
  String get settingsBusinessName => 'Geschäftsname';

  @override
  String get settingsDescription => 'Beschreibung';

  @override
  String get settingsDescriptionHint => 'Kurze Beschreibung Ihres Geschäfts';

  @override
  String get settingsLogoUrl => 'Logo-URL';

  @override
  String get settingsOrderPhone => 'Bestelltelefon (WhatsApp)';

  @override
  String get subscriptionPlanTitle => 'Abonnement';

  @override
  String get changePlan => 'Plan ändern';

  @override
  String get settingsOrderPhoneNote =>
      'Wird genutzt, wenn Ihr Online-Shop Bestellungen per WhatsApp sendet.';

  @override
  String get productsByCategoryEmpty =>
      'Noch keine Produkte. Fügen Sie welche unter Produkte hinzu.';

  @override
  String get offerAddTitle => 'Angebot hinzufügen';

  @override
  String get offerEditTitle => 'Angebot bearbeiten';

  @override
  String get offerSave => 'Angebot speichern';

  @override
  String get offerActive => 'Aktiv';

  @override
  String offerDurationLabel(int days) {
    return 'Dauer: $days Tage';
  }

  @override
  String get offerProductsLabel => 'Produkte im Angebot';

  @override
  String get offerNoProducts =>
      'Keine aktiven Produkte. Zuerst Produkte anlegen.';

  @override
  String get offerPickProducts => 'Mindestens ein Produkt auswählen.';

  @override
  String get offerModePercent => '% Rabatt';

  @override
  String get offerModeSalePrice => 'Aktionspreis';

  @override
  String get offerPercentLabel => 'Rabatt in Prozent';

  @override
  String get offerSalePriceLabel => 'Verkaufspreis (EUR)';

  @override
  String get offerInvalidPercent => 'Rabattprozent muss größer als 0 sein.';

  @override
  String get offerInvalidPrice => 'Gültigen Verkaufspreis eingeben.';

  @override
  String get offersEmpty => 'Noch keine Angebote.';

  @override
  String get offerColumnProducts => 'Produkte';

  @override
  String get offerColumnDiscount => 'Rabatt';

  @override
  String get offerColumnPeriod => 'Zeitraum';

  @override
  String get offerStatusLive => 'Live';

  @override
  String get offerStatusScheduled => 'Geplant';

  @override
  String get offerDeleteTitle => 'Angebot löschen?';

  @override
  String offerDeleteMessage(String title) {
    return '\"$title\" löschen?';
  }

  @override
  String get offerDeleteConfirm => 'Löschen';

  @override
  String offerSummaryPercent(double percent) {
    return '$percent% Rabatt';
  }

  @override
  String offerSummarySalePrice(double price) {
    return '€$price';
  }

  @override
  String get apiLivePreview => 'Live-Vorschau';

  @override
  String get apiLivePreviewTap => 'Preview beim products-Endpunkt tippen';

  @override
  String get apiLivePreviewLoading => 'Katalog-Vorschau wird geladen…';

  @override
  String get apiLivePreviewEmpty => 'Geschäft wählen für Vorschau.';

  @override
  String get apiPreviewRefresh => 'Vorschau aktualisieren';

  @override
  String get apiIntegrationInfo => 'Integrationsanleitung';

  @override
  String get apiIntegrationInfoTitle => 'Webshop-Integration';

  @override
  String get apiIntegrationGuideTitle => 'Web-Integrationsanleitung';

  @override
  String get apiIntegrationGuideSubtitle =>
      'So verbinden Sie Ihre Website mit dieser API.';

  @override
  String get apiIntegrationReadFull => 'Vollständige Anleitung';
}
