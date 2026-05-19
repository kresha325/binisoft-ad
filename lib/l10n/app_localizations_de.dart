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
  String get navAppointments => 'Termine / Reservierungen';

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
  String get navServices => 'Dienstleistungen';

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
  String get menuCreateBusiness => 'Shop hinzufügen';

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
      'Ein Login, mehrere getrennte Shops. Aktiven Shop wechseln oder neuen anlegen (Aktivierung kostenpflichtig).';

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
  String get pageServicesTitle => 'Dienstleistungen';

  @override
  String get pageServicesSubtitle =>
      'Angebotene Leistungen (für Reservierungen und Katalog).';

  @override
  String get serviceAddTitle => 'Leistung hinzufügen';

  @override
  String get serviceEditTitle => 'Leistung bearbeiten';

  @override
  String get serviceSave => 'Leistung speichern';

  @override
  String get serviceName => 'Name';

  @override
  String get serviceDescription => 'Beschreibung';

  @override
  String get serviceDurationMinutes => 'Dauer (Minuten)';

  @override
  String get serviceDurationHint => 'z. B. 60';

  @override
  String get servicePriceEur => 'Preis (€)';

  @override
  String get serviceActive => 'Aktiv';

  @override
  String get servicesEmpty =>
      'Noch keine Leistungen. Erste Leistung hinzufügen.';

  @override
  String get serviceCreated => 'Leistung erstellt';

  @override
  String get serviceUpdated => 'Leistung aktualisiert';

  @override
  String get serviceDeleted => 'Leistung gelöscht';

  @override
  String get appointmentServicePick => 'Leistung wählen';

  @override
  String get appointmentServiceCustom => 'Andere (manuell eingeben)';

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
  String get pageAppointmentsTitle => 'Termine / Reservierungen';

  @override
  String get pageAppointmentsSubtitle =>
      'Reservierungen mit Kundendaten, Leistungsart und Erinnerungen verwalten.';

  @override
  String get appointmentAdd => 'Neue Reservierung';

  @override
  String get appointmentEditTitle => 'Reservierung bearbeiten';

  @override
  String get appointmentFirstName => 'Vorname';

  @override
  String get appointmentLastName => 'Nachname';

  @override
  String get appointmentFullName => 'Name';

  @override
  String get appointmentFirstNameRequired => 'Vorname ist erforderlich';

  @override
  String get appointmentLastNameRequired => 'Nachname ist erforderlich';

  @override
  String get appointmentDescription => 'Beschreibung';

  @override
  String get appointmentDescriptionRequired => 'Beschreibung ist erforderlich';

  @override
  String get appointmentServiceType => 'Leistungsart';

  @override
  String get appointmentServiceTypeRequired => 'Leistungsart ist erforderlich';

  @override
  String get appointmentPhone => 'Telefonnummer';

  @override
  String get appointmentPhoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get appointmentScheduledAt => 'Terminzeit';

  @override
  String get appointmentCreatedAt => 'Erstellt';

  @override
  String get appointmentReminder => 'Erinnerung';

  @override
  String get appointmentReminderNone => 'Keine Erinnerung';

  @override
  String get appointmentReminder15 => '15 Minuten vorher';

  @override
  String get appointmentReminder30 => '30 Minuten vorher';

  @override
  String get appointmentReminder60 => '1 Stunde vorher';

  @override
  String get appointmentReminder120 => '2 Stunden vorher';

  @override
  String get appointmentReminder1440 => '1 Tag vorher';

  @override
  String get appointmentStatusScheduled => 'Geplant';

  @override
  String get appointmentStatusCompleted => 'Abgeschlossen';

  @override
  String get appointmentStatusCancelled => 'Abgesagt';

  @override
  String get appointmentEmpty =>
      'Noch keine Termine. Erstellen Sie den ersten Termin.';

  @override
  String get appointmentEmptyDay => 'Keine Reservierungen an diesem Tag.';

  @override
  String get appointmentTime => 'Uhrzeit';

  @override
  String get appointmentCalendarToday => 'Heute';

  @override
  String get appointmentCalendarPrevMonth => 'Vorheriger Monat';

  @override
  String get appointmentCalendarNextMonth => 'Nächster Monat';

  @override
  String appointmentDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Reservierungen an diesem Tag',
      one: '1 Reservierung an diesem Tag',
      zero: 'Keine Reservierungen an diesem Tag',
    );
    return '$_temp0';
  }

  @override
  String get appointmentSave => 'Termin speichern';

  @override
  String get appointmentDeleteConfirm => 'Termin löschen?';

  @override
  String get appointmentMarkCompleted => 'Als erledigt markieren';

  @override
  String get appointmentMarkCancelled => 'Termin absagen';

  @override
  String get appointmentReminderNotificationTitle => 'Terminerinnerung';

  @override
  String appointmentReminderNotificationBody(
    String name,
    String serviceType,
    String when,
  ) {
    return '$name — $serviceType — $when';
  }

  @override
  String get searchAppointments => 'Reservierungen suchen…';

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
  String get dashboardAppointmentsToday => 'Termine heute';

  @override
  String get dashboardUpcomingAppointments => 'Kommende Termine';

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
  String get categoryTemplatesTitle =>
      'Vorgeschlagene Kategorien für Ihre Geschäftsart';

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
  String get settingsPublicShopProfileTitle => 'Öffentliches Shop-Profil';

  @override
  String get settingsPublicShopProfileSubtitle =>
      'Texte, Logo, Standort und Kontakt im Online-Shop. Layout (Farben, Bereiche) im Site-Editor unten.';

  @override
  String get settingsHeroTagline => 'Hero-Slogan';

  @override
  String get settingsHeroTaglineHint => 'Absatz unter dem Geschäftsnamen';

  @override
  String get settingsAboutBio => 'Über uns (Bio)';

  @override
  String get settingsAboutBioHint => 'Volltext für den Bereich Über uns';

  @override
  String get settingsOpeningHours => 'Öffnungszeiten';

  @override
  String get settingsOpeningHoursHint => 'z. B. Mo–Fr 9:00–22:00';

  @override
  String get siteEditorProfileHintHero =>
      'Name, Slogan und Cover kommen aus dem Profil oben — hier nur Bereich, Menülabel und optionales Hero-Bild.';

  @override
  String get siteEditorProfileHintAbout =>
      'Über-uns-Text kommt aus dem Bio-Feld im Profil — hier nur Bereich und Menülabel.';

  @override
  String get shopPreviewTitle => 'Shop-Vorschau';

  @override
  String get shopPreviewDraftNote =>
      'Vorschau mit aktuellen Formularwerten — noch nicht gespeichert.';

  @override
  String get shopPreviewButton => 'Vorschau';

  @override
  String get shopPreviewOpenLive => 'Live-Shop öffnen (gespeichert)';

  @override
  String get shopPreviewSections => 'Bereiche auf der Seite';

  @override
  String get shopPreviewEmptyHint =>
      'Name, Slogan und Kontakt ausfüllen für mehr Vorschau.';

  @override
  String get settingsBusinessName => 'Geschäftsname';

  @override
  String get settingsDescription => 'Beschreibung';

  @override
  String get settingsDescriptionHint => 'Kurze Beschreibung Ihres Geschäfts';

  @override
  String get settingsLogoUrl => 'Logo-URL';

  @override
  String get settingsCoverUrl => 'Shop-Titelbild';

  @override
  String get settingsCoverNote =>
      'Wird oben im öffentlichen Shop-Profil angezeigt.';

  @override
  String get settingsBusinessType => 'Geschäftsart';

  @override
  String get settingsCity => 'Stadt';

  @override
  String get settingsCityHint => 'z. B. Pristina';

  @override
  String get settingsState => 'Land / Region';

  @override
  String get settingsStateHint => 'z. B. Kosovo';

  @override
  String get settingsLocationMaps => 'Standort';

  @override
  String get settingsLocationMapsHint =>
      'https://maps.google.com/... oder maps.app.goo.gl/...';

  @override
  String get settingsLocationMapsNote =>
      'Nur Google-Maps-Link (URL) aus Teilen — kein iframe-Einbettungscode.';

  @override
  String get settingsGoogleMapsUrlInvalid =>
      'Bitte einen gültigen Google-Maps-Link einfügen (maps.google.com oder maps.app.goo.gl).';

  @override
  String get settingsGoogleMapsNoIframe =>
      'Kein iframe-HTML einfügen. In Google Maps Teilen → nur den Link (URL) kopieren.';

  @override
  String get settingsWebsite => 'Webseite';

  @override
  String get websiteSectionTitle => 'Website';

  @override
  String get websiteSectionSubtitle =>
      'Öffentliche Seite für Ihren Shop — Selbstbedienung oder individuell mit unserem Team.';

  @override
  String get websiteChoosePlan => 'Art der Website wählen';

  @override
  String get websiteChoosePlanHint => 'Wählen Sie oben eine Option.';

  @override
  String get websiteSimpleTitle => 'Einfache Site';

  @override
  String get websiteSimpleBadge => 'Inklusive';

  @override
  String get websiteSimpleDescription =>
      'Fertiger Shop mit Produkten, Angeboten und WhatsApp-Bestellungen.';

  @override
  String get websiteSimpleFeature1 =>
      'MARKET-Vorlage: Hero, Produkte, Angebote, Galerie';

  @override
  String get websiteSimpleFeature2 => 'Farben, Bereiche und Social Links';

  @override
  String get websiteSimpleFeature3 =>
      'Live unter kresha325.github.io/Binisoft-marketplace/ihr-slug';

  @override
  String get websiteProTitle => 'Professionelle Website';

  @override
  String get websiteProBadge => 'Individuell';

  @override
  String get websiteProDescription =>
      'Eigenes Design, Domain und erweiterte Seiten — von Binisoft.';

  @override
  String get websiteProFeature1 => 'Individuelles Layout und Branding';

  @override
  String get websiteProFeature2 => 'Domain, SSL und SEO-Beratung';

  @override
  String get websiteProFeature3 => 'Persönlicher Support';

  @override
  String get websiteSimpleSetupTitle => 'Einfache Site erstellen';

  @override
  String get websiteSimpleSetupNote =>
      'Einmal veröffentlichen, Design unten anpassen.';

  @override
  String get websiteSimpleTemplateName =>
      'MARKET v1 — Hero, Angebote, Produkte, Galerie, Kontakt';

  @override
  String get websiteGenerateSimple => 'Site erstellen / veröffentlichen';

  @override
  String get websiteProContactTitle => 'Professionelle Website anfragen';

  @override
  String get websiteProContactBody =>
      'Beschreiben Sie Ihr Unternehmen und Ihre Ziele. Wir melden uns mit Angebot und Zeitplan.';

  @override
  String get websiteProContactButton => 'E-Mail an Binisoft';

  @override
  String get websiteProContactEmail => 'Oder schreiben Sie an';

  @override
  String get websiteProRequested => 'Anfrage gesendet';

  @override
  String get websiteTemplateLabel => 'Vorlage';

  @override
  String get websiteLiveUrlLabel => 'Live-URL';

  @override
  String get websiteOpenSite => 'Seite öffnen';

  @override
  String get websiteCopyLink => 'Link kopieren';

  @override
  String get websiteCustomDomainLabel => 'Eigene Domain (GoDaddy usw.)';

  @override
  String get websiteCustomDomainNote =>
      'Nach dem Deploy DNS (CNAME) beim Registrar setzen.';

  @override
  String get websiteDeployButton => 'Website veröffentlichen';

  @override
  String get websiteDeploySuccess => 'Website veröffentlicht';

  @override
  String get websiteSlugRequired => 'Zuerst Shop-Slug festlegen (Geschäfte).';

  @override
  String get websiteLastDeploy => 'Letzte Veröffentlichung';

  @override
  String get websiteDnsTitle => 'DNS-Einträge';

  @override
  String get websiteLinkCopied => 'Link kopiert';

  @override
  String get siteEditorTitle => 'Shop-Design';

  @override
  String get siteEditorSubtitle =>
      'Farben, Bereiche, Galerie und Social Links — ohne doppelte Texte (die stehen im Profil oben).';

  @override
  String get siteEditorColorsTitle => 'Farben';

  @override
  String get siteEditorColorPrimary => 'Primär (Navy)';

  @override
  String get siteEditorColorAccent => 'Akzent (Gelb)';

  @override
  String get siteEditorColorBackground => 'Hintergrund';

  @override
  String get siteEditorColorText => 'Text';

  @override
  String get siteEditorLayoutLabel => 'Layout';

  @override
  String get siteEditorLayoutDefault => 'Standard';

  @override
  String get siteEditorLayoutWide => 'Breit';

  @override
  String get siteEditorSectionsTitle => 'Bereiche';

  @override
  String get siteEditorSocialsTitle => 'Soziale Netzwerke';

  @override
  String get siteEditorFooterTitle => 'Fußzeile';

  @override
  String get siteEditorFooterLocation => 'Standort anzeigen';

  @override
  String get siteEditorFooterPhone => 'Telefon anzeigen';

  @override
  String get siteEditorFooterWhatsApp => 'WhatsApp-Button';

  @override
  String get siteEditorSaveButton => 'Design speichern';

  @override
  String get siteEditorSaved => 'Design gespeichert';

  @override
  String get siteSectionEnabled => 'Auf der Seite sichtbar';

  @override
  String get siteSectionDisabled => 'Ausgeblendet';

  @override
  String get siteSectionShowOnSite => 'Bereich anzeigen';

  @override
  String get siteSectionNavLabel => 'Menülabel (optional)';

  @override
  String get siteSectionTitle => 'Bereichstitel';

  @override
  String get siteSectionDescription => 'Beschreibung (optional)';

  @override
  String get siteSectionHero => 'Hero';

  @override
  String get siteSectionOffers => 'Angebote';

  @override
  String get siteSectionProducts => 'Produkte';

  @override
  String get siteSectionServices => 'Dienstleistungen';

  @override
  String get siteSectionAbout => 'Über uns';

  @override
  String get siteSectionGallery => 'Galerie';

  @override
  String get siteSectionContact => 'Kontakt';

  @override
  String get siteSectionHeroH1 => 'Hero-Überschrift (H1)';

  @override
  String get siteSectionHeroP => 'Hero-Text';

  @override
  String get siteHeroUseProfileCover =>
      'Titelbild aus den Einstellungen verwenden';

  @override
  String get siteHeroImage => 'Hero-Hintergrundbild';

  @override
  String get siteGalleryHint => 'Bis zu 5 — Bild und/oder YouTube pro Platz.';

  @override
  String get siteSectionCtaLabel => 'Primärer Button-Text';

  @override
  String get siteSectionSecondaryCtaLabel => 'Sekundärer Button-Text';

  @override
  String get siteSectionTrustBullets => 'Vertrauenspunkte (Hero)';

  @override
  String get siteSectionTrustBulletsHint => 'Eine Zeile pro Punkt, max. 5.';

  @override
  String get siteCtaTargetLabel => 'Button führt zu';

  @override
  String get siteCtaTargetProducts => 'Produkte';

  @override
  String get siteCtaTargetServices => 'Dienstleistungen';

  @override
  String get siteCtaTargetContact => 'Kontakt';

  @override
  String get siteCtaTargetOffers => 'Angebote';

  @override
  String get siteCtaTargetWhatsapp => 'WhatsApp (direkt öffnen)';

  @override
  String get siteCtaTypeHint =>
      'Kliniken sollten z. B. «Termin buchen» oder «Kontakt» nutzen, nicht «Bestellen». Texte und Aktionen sind frei anpassbar.';

  @override
  String get siteCtaApplyTypeSuggestions =>
      'Vorschläge für Geschäftsart übernehmen';

  @override
  String get siteGalleryAdd => 'Galerieeintrag hinzufügen';

  @override
  String get siteGalleryItem => 'Eintrag';

  @override
  String get siteGalleryImage => 'Bild';

  @override
  String get siteGalleryYoutube => 'YouTube-URL (optional)';

  @override
  String get siteGalleryCaption => 'Beschriftung (optional)';

  @override
  String get siteSocialFacebook => 'Facebook';

  @override
  String get siteSocialInstagram => 'Instagram';

  @override
  String get siteSocialTiktok => 'TikTok';

  @override
  String get siteSocialYoutube => 'YouTube';

  @override
  String get siteSocialLinkedin => 'LinkedIn';

  @override
  String get siteSocialX => 'X (Twitter)';

  @override
  String get siteSocialWhatsapp => 'WhatsApp';

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
  String get offerStatusExpired => 'Abgelaufen';

  @override
  String get searchOffers => 'Angebote suchen…';

  @override
  String get offerSectionDetails => 'Grunddaten';

  @override
  String get offerSectionDuration => 'Laufzeit & Sichtbarkeit';

  @override
  String get offerRenewHint =>
      'Beim Speichern beginnt eine neue Laufzeit ab heute (Angebot ist abgelaufen).';

  @override
  String get offerSaved => 'Angebot gespeichert';

  @override
  String get offerUpdated => 'Angebot aktualisiert';

  @override
  String get offerDeleted => 'Angebot gelöscht';

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
  String get apiPublicShopTitle => 'Online-Shop';

  @override
  String get apiPublicShopSubtitle =>
      'Jedes Geschäft hat eine öffentliche Speisekarte unter diesem Link. API-Schlüssel erzeugen, dann den Shop einmal mit ?key=… öffnen.';

  @override
  String get apiPublicShopCopy => 'Shop-Link kopieren';

  @override
  String get apiLinkCopied => 'Link kopiert';

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

  @override
  String get businessesSectionTitle => 'Ihre Shops';

  @override
  String businessesSectionSubtitle(
    int maxBusinesses,
    String planTitle,
    int maxProducts,
  ) {
    return 'Ein Konto · bis zu $maxBusinesses Shops im Plan $planTitle. Jeder Shop hat eigenen Katalog, Bestellungen, Angebote und öffentliche API (bis $maxProducts Produkte pro Shop).';
  }

  @override
  String businessesQuotaUsage(int owned, int max) {
    return '$owned von $max Shops';
  }

  @override
  String businessesAddStore(int next, int max) {
    return 'Shop hinzufügen ($next/$max)';
  }

  @override
  String businessesAddStoreFull(int owned, int max) {
    return 'Weiteren Shop hinzufügen ($owned/$max)';
  }

  @override
  String businessesLimitReached(int max, String planCode) {
    return 'Limit von $max Shops im Plan $planCode erreicht. Upgrade unter Einstellungen.';
  }

  @override
  String get businessesEmpty =>
      'Noch kein Shop. Erstellen Sie unten Ihren ersten E-Commerce-Shop.';

  @override
  String get businessTileActive => 'Aktiv';

  @override
  String get businessTileSwitch => 'Öffnen';

  @override
  String businessTileApiSlug(String slug) {
    return 'Shop-URL: $slug';
  }

  @override
  String get businessTileHint => 'Eigener Katalog, Bestellungen & API';

  @override
  String get createFirstStoreTitle => 'Ersten Shop anlegen';

  @override
  String get createFirstStoreBody =>
      'Ein Shop ist ein vollständiger E-Commerce-Bereich: eigene Produkte, Kategorien, Angebote und öffentliche API für Website/App. Ein Login — weitere Shops jederzeit (jeder zusätzliche Shop wird separat berechnet).';

  @override
  String get createFirstStoreButton => 'Ersten Shop anlegen';

  @override
  String createStoreDialogTitle(int next, int max) {
    return 'Neuer Shop ($next von $max)';
  }

  @override
  String createStoreDialogIntro(String price) {
    return 'Jeder neue Shop benötigt eine einmalige Aktivierung ($price, erster Monat inkl.). Rechnung wird diesem Konto gutgeschrieben.';
  }

  @override
  String get createStoreContinuePayment => 'Weiter zur Zahlung';

  @override
  String createStoreQuotaSnack(int max) {
    return 'Shop-Limit erreicht ($max im aktuellen Plan).';
  }

  @override
  String get createStoreSuccess => 'Shop erstellt · Rechnung gespeichert';

  @override
  String get switcherCreateStore => 'Shop anlegen';

  @override
  String switcherMenuCreateStore(int owned, int max) {
    return 'Shop hinzufügen ($owned/$max)';
  }

  @override
  String get switcherTooltip => 'Aktiver Shop — wechseln oder hinzufügen';

  @override
  String activeStoreBanner(String name) {
    return 'Verwaltung: $name';
  }

  @override
  String get activeStoreBannerHint =>
      'Dashboard, Produkte und Bestellungen gelten nur für diesen Shop.';

  @override
  String get activeStoreBannerManage => 'Alle Shops';

  @override
  String get editProduct => 'Produkt bearbeiten';

  @override
  String get saveProduct => 'Produkt speichern';

  @override
  String get coreDetails => 'Grunddaten';

  @override
  String get productNameLabel => 'Name *';

  @override
  String get productDescriptionLabel => 'Beschreibung';

  @override
  String get productPriceLabel => 'Preis';

  @override
  String get productCategoryLabel => 'Kategorie';

  @override
  String get selectOption => 'Auswählen';

  @override
  String get productActiveLabel => 'Aktiv';

  @override
  String get customFieldsSection => 'Benutzerdefinierte Felder';

  @override
  String couldNotLoadCustomFields(String message) {
    return 'Felder konnten nicht geladen werden: $message';
  }

  @override
  String get productSaved => 'Produkt gespeichert';

  @override
  String get productUpdated => 'Produkt aktualisiert';

  @override
  String get productDeleted => 'Produkt gelöscht';

  @override
  String get deleteProductTitle => 'Produkt löschen';

  @override
  String deleteProductMessage(String name) {
    return '\"$name\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String productLimitReached(String usage) {
    return 'Produktlimit erreicht ($usage). Upgrade unter Einstellungen.';
  }

  @override
  String get productImageInvalidUrl =>
      'Ungültige Bild-URL. Erneut hochladen oder öffentliche https-URL verwenden.';

  @override
  String get productImagesTitle => 'Produktfotos';

  @override
  String productImagesSubtitle(int max) {
    return 'Bis zu $max Bilder. Nur aktive Fotos erscheinen im Online-Shop.';
  }

  @override
  String productImagesMax(int max) {
    return 'Maximal $max Fotos pro Produkt.';
  }

  @override
  String get productImagesActive => 'Aktiv';

  @override
  String get productImagesAddUrl => 'URL hinzufügen';

  @override
  String get variantsSectionTitle => 'Varianten';

  @override
  String get variantsSectionSubtitle =>
      'Select-Felder als Achsen (z. B. Größe, Farbe), dann SKU-Zeilen mit Preis und Bestand generieren.';

  @override
  String get variantsSelectAxes => 'Varianten-Achsen';

  @override
  String get variantsGenerate => 'Kombinationen erzeugen';

  @override
  String get variantsSku => 'SKU';

  @override
  String get variantsPrice => 'Preis';

  @override
  String get variantsQuantity => 'Menge';

  @override
  String get variantsNoAxes =>
      'Select-Felder mit Optionen unter Benutzerdefinierte Felder anlegen (z. B. Größe, Farbe).';

  @override
  String get variantsApplyBasePrice => 'Basispreis auf alle anwenden';

  @override
  String get variantsClear => 'Varianten löschen';

  @override
  String variantsRowLabel(String labels) {
    return '$labels';
  }

  @override
  String get saveField => 'Feld speichern';

  @override
  String get fieldLabel => 'Bezeichnung';

  @override
  String get fieldKey => 'Schlüssel (Key)';

  @override
  String get fieldType => 'Typ';

  @override
  String get fieldRequired => 'Pflichtfeld bei Produkten';

  @override
  String get fieldActive => 'Aktiv';

  @override
  String get fieldOptionsHint => 'Optionen (eine pro Zeile)';

  @override
  String get attrTypeText => 'Text (kurz)';

  @override
  String get attrTypeTextarea => 'Text (lang)';

  @override
  String get attrTypeNumber => 'Zahl';

  @override
  String get attrTypeSelect => 'Auswahl';

  @override
  String get attrTypeMultiSelect => 'Mehrfachauswahl';

  @override
  String get attrTypeColor => 'Farbe';

  @override
  String get attrTypeBoolean => 'Ja/Nein';

  @override
  String get defaultFieldsTitle => 'Standardfelder';

  @override
  String get defaultFieldsSubtitle =>
      'Aktivierte Felder sind beim Produkt anlegen Pflicht.';

  @override
  String get businessNameLabel => 'Geschäftsname *';

  @override
  String get businessTypeLabel => 'Geschäftsart *';

  @override
  String get businessTypeSelect => 'Art wählen';

  @override
  String get businessTypeRequired => 'Bitte wählen Sie eine Geschäftsart.';

  @override
  String get businessTypeRetail => 'Einzelhandel';

  @override
  String get businessTypeFashion => 'Mode & Accessoires';

  @override
  String get businessTypeElectronics => 'Elektronik & Technik';

  @override
  String get businessTypeIt => 'IT & Software';

  @override
  String get businessTypeDigitalAgency => 'Digitalagentur & Marketing';

  @override
  String get businessTypeConstruction => 'Bau & Renovierung';

  @override
  String get businessTypeRealEstate => 'Immobilien';

  @override
  String get businessTypePhotography => 'Foto & Video';

  @override
  String get businessTypeEvents => 'Events & Hochzeiten';

  @override
  String get businessTypeLogistics => 'Transport & Logistik';

  @override
  String get businessTypeAgriculture => 'Landwirtschaft & Hof';

  @override
  String get businessTypeGrocery => 'Lebensmittel & Supermarkt';

  @override
  String get businessTypeConvenienceStore => 'Spätkauf / 24h-Markt';

  @override
  String get businessTypeBakery => 'Bäckerei';

  @override
  String get businessTypePastry => 'Konditorei & Torten';

  @override
  String get businessTypeWholesale => 'Großhandel / B2B';

  @override
  String get businessTypeRestaurant => 'Restaurant';

  @override
  String get businessTypePizzeria => 'Pizzeria';

  @override
  String get businessTypeCafe => 'Café';

  @override
  String get businessTypeFastFood => 'Fast Food & Take-away';

  @override
  String get businessTypeBar => 'Bar & Lounge';

  @override
  String get businessTypeCatering => 'Catering & Bankett';

  @override
  String get businessTypeButcher => 'Metzgerei';

  @override
  String get businessTypeIceCream => 'Eis & Desserts';

  @override
  String get businessTypeFlowerShop => 'Blumenladen';

  @override
  String get businessTypeJewelry => 'Schmuck & Uhren';

  @override
  String get businessTypeBookstore => 'Buchhandlung & Schreibwaren';

  @override
  String get businessTypePharmacy => 'Apotheke & Gesundheit';

  @override
  String get businessTypePetShop => 'Tierhandlung & Grooming';

  @override
  String get businessTypeVeterinary => 'Tierarztpraxis';

  @override
  String get businessTypeServices => 'Allgemeine Dienstleistungen (Termine)';

  @override
  String get businessTypeSalon => 'Friseur & Kosmetik';

  @override
  String get businessTypeSpa => 'Spa & Wellness';

  @override
  String get businessTypeClinic => 'Klinik & Arztpraxis';

  @override
  String get businessTypeDental => 'Zahnarztpraxis';

  @override
  String get businessTypeAutomotive => 'Kfz-Service & Reparatur';

  @override
  String get businessTypeFitness => 'Fitnessstudio';

  @override
  String get businessTypeEducation => 'Bildung & Nachhilfe';

  @override
  String get businessTypeProfessional => 'Freie Berufe (Recht, Buchhaltung…)';

  @override
  String get businessTypeHomeServices => 'Hausservice (Reparatur, Reinigung…)';

  @override
  String get businessTypeHotel => 'Hotel & Unterkunft';

  @override
  String get businessTypeOther => 'Sonstiges';

  @override
  String get businessSlugLabel => 'URL-Slug *';

  @override
  String get businessSlugHelper =>
      'Öffentliche API: /api/public/ihr-slug/products';

  @override
  String get internalSlugLabel => 'Interner Slug *';

  @override
  String get internalSlugHint => 'elektronik';

  @override
  String get internalSlugHelper =>
      'Wird nicht übersetzt. Für API, Beziehungen und Datenbank (z. B. elektronik, pizza-getraenke).';

  @override
  String get internalSlugImmutableHelper =>
      'Interner Slug kann nach der Erstellung nicht geändert werden.';

  @override
  String get internalSlugImmutableNote =>
      'Slug bleibt für stabile API-Links unverändert.';

  @override
  String get internalSlugTaken => 'Dieser interne Slug wird bereits verwendet.';

  @override
  String get localizedContentSection => 'Übersetzungen';

  @override
  String get localizedContentHelper =>
      'Nur die Standard-Sprache ist Pflicht. Auto translate füllt andere Sprachen.';

  @override
  String get autoTranslateButton => 'Auto translate';

  @override
  String get autoTranslateNeedSource =>
      'Zuerst Name oder Beschreibung in der Standardsprache ausfüllen.';

  @override
  String get autoTranslateDone =>
      'Übersetzungen erstellt. Vor dem Speichern prüfen.';

  @override
  String get seoTitleLabel => 'SEO-Titel';

  @override
  String get seoDescriptionLabel => 'SEO-Beschreibung';

  @override
  String get localizedSlugsSection => 'Lokalisierte Shop-URL-Slugs';

  @override
  String localizedSlugsHelper(String slug) {
    return 'Optional pro Sprache. Standard ist \"$slug\".';
  }

  @override
  String get businessCreatedInvoiceFailed =>
      'Shop erstellt, Rechnung konnte nicht gespeichert werden. Siehe Abrechnung.';

  @override
  String get paymentTitle => 'Zahlung abschließen';

  @override
  String paymentSubtitleRegistration(String plan) {
    return 'Binisoft Admin · Plan $plan';
  }

  @override
  String paymentSubtitleNewBusiness(String name) {
    return 'Neuer Shop · $name';
  }

  @override
  String paymentPayRegistration(String amount) {
    return '$amount zahlen und Konto erstellen';
  }

  @override
  String paymentPayNewBusiness(String amount) {
    return '$amount zahlen und Shop erstellen';
  }

  @override
  String get paymentDemoBannerRegistration =>
      'Demo-Modus: keine echte Belastung. Bestätigen zum Konto erstellen.';

  @override
  String get paymentDemoBannerNewBusiness =>
      'Demo-Modus: keine echte Belastung. Bestätigen zum Shop aktivieren.';

  @override
  String get paymentActivationRegistration => 'Registrierung (1. Monat inkl.)';

  @override
  String get paymentActivationNewBusiness =>
      'Shop-Aktivierung (1. Monat inkl.)';

  @override
  String get paymentMethod => 'Zahlungsmethode';

  @override
  String get paymentCard => 'Karte';

  @override
  String get paymentPaypal => 'PayPal';

  @override
  String get paymentAcceptTerms =>
      'Ich akzeptiere die Abo-Bedingungen und die monatliche Gebühr nach dem ersten Monat.';

  @override
  String get paymentAcceptTermsRequired => 'Bitte die Bedingungen akzeptieren.';

  @override
  String get paymentInvalidCard => 'Gültige Kartennummer eingeben.';

  @override
  String get paymentCancel => 'Abbrechen';

  @override
  String get planChooseTitle => 'Plan wählen';

  @override
  String planChooseSubtitle(int max) {
    return '€30 + €6/Monat pro 100 Produkte (1. Monat in der Registrierung). Max. $max Produkte pro Shop.';
  }

  @override
  String get planBillingSoon =>
      'Abrechnung folgt. Limits gelten sofort nach Aktualisierung.';

  @override
  String get planBillingLater =>
      'Jetzt registrieren mit Plan-Limits. Abrechnung wird später aktiviert.';

  @override
  String planPerMonth(String price) {
    return '$price/Monat nach dem 1. Monat';
  }

  @override
  String planRegistration(String price) {
    return 'Registrierung $price (1. Monat inkl.)';
  }

  @override
  String get paymentThenMonthly => 'Danach monatlich';

  @override
  String get paymentTotalDueToday => 'Heute fällig';

  @override
  String planProductsCount(String title, int count) {
    return '$title · $count Produkte';
  }

  @override
  String get defaultFieldRequired => '· Pflicht';

  @override
  String get teamSectionTitle => 'Team & Rollen';

  @override
  String get teamSectionSubtitle =>
      'Manager oder Mitarbeiter per E-Mail einladen — Einladungscode teilen, Registrierung unter Team beitreten.';

  @override
  String get teamInviteEmail => 'E-Mail';

  @override
  String get teamInviteRole => 'Rolle';

  @override
  String get teamInviteButton => 'Einladen';

  @override
  String get teamEmpty => 'Noch keine Teammitglieder.';

  @override
  String get teamRemoveTitle => 'Teammitglied entfernen?';

  @override
  String get teamRemoveMessage => 'Zugang zu diesem Shop wird entzogen.';

  @override
  String get teamRemoveConfirm => 'Entfernen';

  @override
  String get teamRemoved => 'Teammitglied entfernt';

  @override
  String get teamInviteAssigned =>
      'Teammitglied hinzugefügt — kann sich mit bestehendem Konto anmelden.';

  @override
  String teamInviteCreated(String code) {
    return 'Einladungscode: $code — teilen; Registrierung unter Team beitreten.';
  }

  @override
  String teamInviteCreatedCopied(String code) {
    return 'Code kopiert: $code — teilen; Registrierung unter Team beitreten.';
  }

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String routerPageNotFound(String path) {
    return 'Seite nicht gefunden: $path\n\nÖffnen: …/binisoft-ad/#/login';
  }

  @override
  String get roleSuperadmin => 'Superadmin';

  @override
  String get roleOwner => 'Inhaber';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleEmployee => 'Mitarbeiter';

  @override
  String get joinTeamTitle => 'Team beitreten';

  @override
  String get joinTeamSubtitle =>
      'Einladungscode vom Shop-Inhaber. Kein Abo nötig.';

  @override
  String get inviteCodeLabel => 'Einladungscode';

  @override
  String get joinTeamButton => 'Konto erstellen & beitreten';

  @override
  String joinTeamSuccess(String store) {
    return 'Willkommen! Beigetreten: $store.';
  }

  @override
  String get haveAccountLogin => 'Bereits ein Konto? Anmelden';

  @override
  String get loginJoinTeam => 'Mit Einladungscode beitreten';
}
