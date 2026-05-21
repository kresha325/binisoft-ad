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
  String get navAppointments => 'Terminet / Rezervimet';

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
  String get navServices => 'Shërbimet';

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
  String get menuCreateBusiness => 'Shto dyqan';

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
      'Një llogari, disa dyqane të ndara. Ndërro dyqanin aktiv ose shto të ri (me pagesë aktivizimi).';

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
  String get pageServicesTitle => 'Shërbimet';

  @override
  String get pageServicesSubtitle =>
      'Shërbimet që ofron biznesi (për rezervime dhe katalog).';

  @override
  String get serviceAddTitle => 'Shto shërbim';

  @override
  String get serviceEditTitle => 'Ndrysho shërbimin';

  @override
  String get serviceSave => 'Ruaj shërbimin';

  @override
  String get serviceName => 'Emri';

  @override
  String get serviceDescription => 'Përshkrimi';

  @override
  String get serviceDurationMinutes => 'Kohëzgjatja (minuta)';

  @override
  String get serviceDurationHint => 'p.sh. 60';

  @override
  String get servicePriceEur => 'Çmimi (€)';

  @override
  String get serviceActive => 'Aktiv';

  @override
  String get servicesEmpty => 'Ende pa shërbime. Shto shërbimin e parë.';

  @override
  String get serviceCreated => 'Shërbimi u krijua';

  @override
  String get serviceUpdated => 'Shërbimi u përditësua';

  @override
  String get serviceDeleted => 'Shërbimi u fshi';

  @override
  String get appointmentServicePick => 'Zgjidh shërbimin';

  @override
  String get appointmentServiceCustom => 'Tjetër (shkruaj manualisht)';

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
  String get pageAppointmentsTitle => 'Terminet / Rezervimet';

  @override
  String get pageAppointmentsSubtitle =>
      'Menaxho rezervimet me emër, përshkrim, lloj shërbimi dhe kujtesa.';

  @override
  String get appointmentAdd => 'Rezervim i ri';

  @override
  String get appointmentEditTitle => 'Ndrysho rezervimin';

  @override
  String get appointmentFirstName => 'Emri';

  @override
  String get appointmentLastName => 'Mbiemri';

  @override
  String get appointmentFullName => 'Emri dhe mbiemri';

  @override
  String get appointmentFirstNameRequired => 'Emri është i detyrueshëm';

  @override
  String get appointmentLastNameRequired => 'Mbiemri është i detyrueshëm';

  @override
  String get appointmentDescription => 'Përshkrimi';

  @override
  String get appointmentDescriptionRequired => 'Përshkrimi është i detyrueshëm';

  @override
  String get appointmentServiceType => 'Lloji i shërbimit';

  @override
  String get appointmentServiceTypeRequired =>
      'Lloji i shërbimit është i detyrueshëm';

  @override
  String get appointmentPhone => 'Numri i telefonit';

  @override
  String get appointmentPhoneRequired =>
      'Numri i telefonit është i detyrueshëm';

  @override
  String get appointmentScheduledAt => 'Koha e terminit';

  @override
  String get appointmentCreatedAt => 'Krijuar';

  @override
  String get appointmentReminder => 'Kujtesë';

  @override
  String get appointmentReminderNone => 'Pa kujtesë';

  @override
  String get appointmentReminder15 => '15 minuta para';

  @override
  String get appointmentReminder30 => '30 minuta para';

  @override
  String get appointmentReminder60 => '1 orë para';

  @override
  String get appointmentReminder120 => '2 orë para';

  @override
  String get appointmentReminder1440 => '1 ditë para';

  @override
  String get appointmentStatusScheduled => 'Planifikuar';

  @override
  String get appointmentStatusCompleted => 'Përfunduar';

  @override
  String get appointmentStatusCancelled => 'Anuluar';

  @override
  String get appointmentEmpty => 'Ende pa rezervime. Krijo rezervimin e parë.';

  @override
  String get appointmentEmptyDay => 'Nuk ka rezervime për këtë ditë.';

  @override
  String get appointmentTime => 'Ora';

  @override
  String get appointmentCalendarToday => 'Sot';

  @override
  String get appointmentCalendarPrevMonth => 'Muaji i kaluar';

  @override
  String get appointmentCalendarNextMonth => 'Muaji tjetër';

  @override
  String appointmentDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rezervime për këtë ditë',
      one: '1 rezervim për këtë ditë',
      zero: 'Nuk ka rezervime për këtë ditë',
    );
    return '$_temp0';
  }

  @override
  String get appointmentSave => 'Ruaj terminin';

  @override
  String get appointmentDeleteConfirm => 'Fshij këtë termin?';

  @override
  String get appointmentMarkCompleted => 'Shëno si përfunduar';

  @override
  String get appointmentMarkCancelled => 'Anulo terminin';

  @override
  String get appointmentReminderNotificationTitle => 'Kujtesë për termin';

  @override
  String appointmentReminderNotificationBody(
    String name,
    String serviceType,
    String when,
  ) {
    return '$name — $serviceType — $when';
  }

  @override
  String get searchAppointments => 'Kërko rezervime…';

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
  String get dashboardAppointmentsToday => 'Terminet sot';

  @override
  String get dashboardUpcomingAppointments => 'Terminet e ardhshme';

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
  String get categoryTemplatesTitle =>
      'Kategori të sugjeruara për llojin e biznesit tuaj';

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
  String get settingsPublicShopProfileTitle => 'Profili i faqes publike';

  @override
  String get settingsPublicShopProfileSubtitle =>
      'Teksti, logo, lokacioni dhe kontakt shfaqen në dyqanin online. Pamja (ngjyrat, seksionet) është te redaktori i faqes më poshtë.';

  @override
  String get settingsHeroTagline => 'Slogan / përshkrim hero';

  @override
  String get settingsHeroTaglineHint =>
      'Paragrafi nën emrin e biznesit në faqen kryesore';

  @override
  String get settingsAboutBio => 'Rreth nesh (bio)';

  @override
  String get settingsAboutBioHint =>
      'Teksti i plotë për seksionin «Rreth nesh»';

  @override
  String get settingsOpeningHours => 'Orari';

  @override
  String get settingsOpeningHoursHint =>
      'p.sh. Hënë–Prem: 09:00–22:00, Sht: 10:00–23:00';

  @override
  String get siteEditorProfileHintHero =>
      'Emri (H1), slogani dhe cover vijnë nga «Profili i faqes publike» lart — këtu vetëm ndez/fik seksionin, etiketën e menysë dhe foto hero opsionale.';

  @override
  String get siteEditorProfileHintAbout =>
      'Mund ta plotësoni këtu ose te «Rreth nesh (bio)» në profilin e biznesit — jo slogani i hero-s.';

  @override
  String get siteSectionAboutBody => 'Teksti «Rreth nesh»';

  @override
  String get siteSectionAboutBodyHint => 'Paragrafi i plotë për këtë seksion';

  @override
  String get shopPreviewTitle => 'Parashikim i dyqanit';

  @override
  String get shopPreviewDraftNote =>
      'Kjo është pamja me të dhënat nga formulari — ende nuk është ruajtur. Pas «Ruaj» do të shfaqet në faqen publike.';

  @override
  String get shopPreviewButton => 'Parashiko';

  @override
  String get shopPreviewOpenLive => 'Hap faqen live (e ruajtur)';

  @override
  String get shopPreviewSections => 'Seksionet në faqe';

  @override
  String get shopPreviewEmptyHint =>
      'Plotësoni emrin, sloganin dhe kontaktin për parashikim më të plotë.';

  @override
  String get settingsBusinessName => 'Emri i biznesit';

  @override
  String get settingsDescription => 'Përshkrimi';

  @override
  String get settingsDescriptionHint => 'Përshkrim i shkurtër i biznesit';

  @override
  String get settingsLogoUrl => 'URL e logos';

  @override
  String get settingsCoverUrl => 'Cover i dyqanit';

  @override
  String get settingsCoverNote =>
      'Shfaqet në krye të profilit të dyqanit publik.';

  @override
  String get settingsBusinessType => 'Lloji i biznesit';

  @override
  String get settingsPostalCode => 'Kodi postar';

  @override
  String get settingsPostalCodeHint => 'p.sh. 20000';

  @override
  String get settingsCity => 'Qyteti';

  @override
  String get settingsCityHint => 'p.sh. Prishtinë';

  @override
  String get settingsState => 'Shteti';

  @override
  String get settingsStateHint => 'p.sh. Kosovë';

  @override
  String get settingsLocationMaps => 'Lokacioni';

  @override
  String get settingsLocationMapsHint =>
      'https://maps.google.com/... ose maps.app.goo.gl/...';

  @override
  String get settingsLocationMapsNote =>
      'Vetëm lidhja (URL) nga Google Maps → Ndaj. Mos ngjisni kod iframe.';

  @override
  String get settingsGoogleMapsUrlInvalid =>
      'Vendosni një lidhje të vlefshme Google Maps (maps.google.com ose maps.app.goo.gl).';

  @override
  String get settingsGoogleMapsNoIframe =>
      'Mos ngjisni kod iframe. Hapni Google Maps → Ndaj → kopjoni vetëm lidhjen (URL).';

  @override
  String get settingsWebsite => 'Faqja web';

  @override
  String get websiteSectionTitle => 'Faqja web';

  @override
  String get websiteSectionSubtitle =>
      'Shto një faqe publike për dyqanin — vetë shërbim ose profesionale me ekipin tonë.';

  @override
  String get websiteChoosePlan => 'Zgjidhni llojin e faqes';

  @override
  String get websiteChoosePlanHint =>
      'Zgjidhni një opsion më sipër për të vazhduar.';

  @override
  String get websiteSimpleTitle => 'Site i thjeshtë';

  @override
  String get websiteSimpleBadge => 'Përfshirë';

  @override
  String get websiteSimpleDescription =>
      'Faqe dyqani e gatshme me produktet, ofertat dhe porositë në WhatsApp.';

  @override
  String get websiteSimpleFeature1 =>
      'Model MARKET: hero, produkte, oferta, galeri';

  @override
  String get websiteSimpleFeature2 => 'Ngjyra, seksione dhe rrjete sociale';

  @override
  String get websiteSimpleFeature3 =>
      'Live në kresha325.github.io/Binisoft-marketplace/slug-u-juaj';

  @override
  String get websiteProTitle => 'Website profesional';

  @override
  String get websiteProBadge => 'Me porosi';

  @override
  String get websiteProDescription =>
      'Dizajn unik, domain dhe faqe të avancuara — nga Binisoft.';

  @override
  String get websiteProFeature1 => 'Layout dhe brand i personalizuar';

  @override
  String get websiteProFeature2 => 'Domain, SSL dhe udhëzime SEO';

  @override
  String get websiteProFeature3 => 'Mbështetje nga ekipi ynë';

  @override
  String get websiteSimpleSetupTitle => 'Gjenero site-in e thjeshtë';

  @override
  String get websiteSimpleSetupNote =>
      'Publiko një herë, pastaj rregullo dizajnin te seksioni më poshtë.';

  @override
  String get websiteSimpleTemplateName =>
      'MARKET v1 — Hero, Oferta, Produkte, Galeri, Kontakt';

  @override
  String get websiteGenerateSimple => 'Gjenero / publiko faqen';

  @override
  String get websiteProContactTitle => 'Na kontaktoni për website profesional';

  @override
  String get websiteProContactBody =>
      'Na tregoni për biznesin dhe qëllimet. Përgjigjemi me ofertë dhe afat.';

  @override
  String get websiteProContactButton => 'Dërgo email te Binisoft';

  @override
  String get websiteProContactEmail => 'Ose shkruani te';

  @override
  String get websiteProRequested => 'Kërkesa u dërgua';

  @override
  String get websiteTemplateLabel => 'Modeli';

  @override
  String get websiteLiveUrlLabel => 'URL aktive';

  @override
  String get websiteOpenSite => 'Hap faqen';

  @override
  String get websiteCopyLink => 'Kopjo linkun';

  @override
  String get websiteCustomDomainLabel => 'Domain i vet (GoDaddy, etj.)';

  @override
  String get websiteCustomDomainNote =>
      'Pas publikimit, vendos CNAME te registrar-i. SSL aktivizohet në Netlify/Firebase.';

  @override
  String get websiteDeployButton => 'Publiko / rifresko faqen';

  @override
  String get websiteDeploySuccess => 'Faqja u publikua';

  @override
  String get websiteSlugRequired =>
      'Vendos slug-un e dyqanit fillimisht (Bizneset).';

  @override
  String get websiteLastDeploy => 'Publikimi i fundit';

  @override
  String get websiteDnsTitle => 'Regjistrat DNS (shto te GoDaddy)';

  @override
  String get websiteLinkCopied => 'Linku u kopjua';

  @override
  String get siteEditorTitle => 'Dizajni i dyqanit';

  @override
  String get siteEditorSubtitle =>
      'Ngjyrat, seksionet e aktivizuara, galeria dhe rrjetet sociale — pa tekst të dyfishtë (ai vjen nga profili lart).';

  @override
  String get siteEditorColorsTitle => 'Ngjyrat';

  @override
  String get siteEditorColorPrimary => 'Kryesore (navy)';

  @override
  String get siteEditorColorAccent => 'Theks (e verdhë)';

  @override
  String get siteEditorColorBackground => 'Sfondi';

  @override
  String get siteEditorColorText => 'Teksti';

  @override
  String get siteEditorLayoutLabel => 'Layout';

  @override
  String get siteEditorLayoutDefault => 'Standard';

  @override
  String get siteEditorLayoutWide => 'I gjerë';

  @override
  String get siteEditorSectionsTitle => 'Seksionet';

  @override
  String get siteEditorSocialsTitle => 'Rrjetet sociale';

  @override
  String get siteEditorFooterTitle => 'Footer';

  @override
  String get siteEditorFooterLocation => 'Shfaq lokacionin';

  @override
  String get siteEditorFooterPhone => 'Shfaq numrin e telefonit';

  @override
  String get siteEditorFooterWhatsApp => 'Butoni WhatsApp';

  @override
  String get siteEditorSaveButton => 'Ruaj dizajnin';

  @override
  String get siteEditorSaved => 'Dizajni u ruajt';

  @override
  String get siteSectionEnabled => 'E dukshme në faqe';

  @override
  String get siteSectionDisabled => 'E fshehur';

  @override
  String get siteSectionShowOnSite => 'Shfaq këtë seksion';

  @override
  String get siteSectionNavLabel => 'Emri në menu (opsional)';

  @override
  String get siteSectionTitle => 'Titulli i seksionit';

  @override
  String get siteSectionDescription => 'Përshkrimi (opsional)';

  @override
  String get siteSectionHero => 'Hero';

  @override
  String get siteSectionOffers => 'Ofertat';

  @override
  String get siteSectionProducts => 'Produktet';

  @override
  String get siteSectionServices => 'Shërbimet';

  @override
  String get siteSectionAbout => 'Rreth nesh';

  @override
  String get siteSectionGallery => 'Galeria';

  @override
  String get siteSectionContact => 'Kontakt';

  @override
  String get siteSectionHeroH1 => 'Titulli hero (H1)';

  @override
  String get siteSectionHeroP => 'Teksti hero (paragraf)';

  @override
  String get siteHeroUseProfileCover =>
      'Përdor cover-in nga profili i biznesit';

  @override
  String get siteHeroImage => 'Imazhi i sfondit hero';

  @override
  String siteGalleryHint(int max) {
    return 'Deri në $max — imazh dhe/ose YouTube për çdo vend.';
  }

  @override
  String get siteSectionCtaLabel => 'Teksti i butonit kryesor';

  @override
  String get siteSectionSecondaryCtaLabel => 'Teksti i butonit dytësor';

  @override
  String get siteSectionTrustBullets => 'Pikat e besimit (hero)';

  @override
  String get siteSectionTrustBulletsHint => 'Një rresht për pikë, deri në 5.';

  @override
  String get siteCtaTargetLabel => 'Ku çon butoni';

  @override
  String get siteCtaTargetProducts => 'Produktet';

  @override
  String get siteCtaTargetServices => 'Shërbimet';

  @override
  String get siteCtaTargetContact => 'Kontakt';

  @override
  String get siteCtaTargetOffers => 'Ofertat';

  @override
  String get siteCtaTargetWhatsapp => 'WhatsApp (hap direkt)';

  @override
  String get siteCtaTypeHint =>
      'Për klinika/ordinanca përdorni «Rezervo termin» ose «Na kontaktoni», jo «Porosit». Teksti dhe veprimi janë të plotësisht të personalizueshëm.';

  @override
  String get siteCtaApplyTypeSuggestions =>
      'Apliko sugjerimet për llojin e biznesit';

  @override
  String get siteGalleryAdd => 'Shto në galeri';

  @override
  String get siteGalleryItem => 'Elementi';

  @override
  String get siteGalleryImage => 'Imazhi';

  @override
  String get siteGalleryYoutube => 'YouTube URL (opsional)';

  @override
  String get siteGalleryCaption => 'Titulli (opsional)';

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
  String get settingsShopCheckoutTitle => 'Porositë online (shporta)';

  @override
  String get settingsShopCheckoutSubtitle =>
      'Çdo opsion aktiv shfaqet në shportë te klienti; joaktiv = fusha fshihet.';

  @override
  String get settingsShopCheckoutCart => 'Shporta online';

  @override
  String get settingsShopCheckoutCartNote =>
      'Joaktiv: pa «Shto në shportë», pa ikonë shporte — vetëm katalog.';

  @override
  String get settingsShopCheckoutName => 'Emri i klientit';

  @override
  String get settingsShopCheckoutDelivery => 'Adresa e dorëzimit';

  @override
  String get settingsShopCheckoutDeliveryNote =>
      'Aktiv vetëm nëse ofroni dërgesë; klienti duhet ta plotësojë.';

  @override
  String get settingsShopCheckoutNotes => 'Kërkesa për porosinë';

  @override
  String get settingsShopCheckoutPhone => 'Telefoni (opsional)';

  @override
  String get settingsOrderPhone => 'Telefoni (thirrje & WhatsApp)';

  @override
  String get settingsContactEmail => 'Email i kontaktit';

  @override
  String get settingsContactEmailNote =>
      'Shfaqet te seksioni Kontakt në faqen publike — klik hap email.';

  @override
  String get subscriptionPlanTitle => 'Plani i abonimit';

  @override
  String get changePlan => 'Ndrysho planin';

  @override
  String get settingsOrderPhoneNote =>
      'Numri për thirrje, WhatsApp dhe porosi nga shporta.';

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
  String offerSavedCount(int count) {
    return '$count oferta u ruajtën';
  }

  @override
  String get offerSeparateSaveHint =>
      'Çdo produkt i zgjedhur ruhet si ofertë e veçantë me titullin e vet.';

  @override
  String get offerEditSplitHint =>
      'Ruajtja ndan këtë ofertë në oferta të veçanta — një produkt për ofertë.';

  @override
  String get offerEditProductsMissing =>
      'Produktet e kësaj oferte nuk u gjetën në katalog (mund të jenë fshirë).';

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
  String get offerQuickTitleHint =>
      'Titulli plotësohet nga produktet e zgjedhura — mund ta ndryshoni.';

  @override
  String get offerSearchProducts => 'Kërko produkt…';

  @override
  String offerResultPrice(String price) {
    return 'Çmimi në ofertë: €$price';
  }

  @override
  String get productPutOnOffer => 'Vendose në ofertë';

  @override
  String get productEditOffer => 'Ndrysho ofertën';

  @override
  String productAlreadyOnOffer(String title) {
    return 'Në ofertë: «$title»';
  }

  @override
  String get apiPublicShopTitle => 'Dyqani online';

  @override
  String get apiPublicShopSubtitle =>
      'Çdo biznes ka menu publike në këtë link. Gjenero API key më poshtë, pastaj hap dyqanin një herë me ?key=… që klientët të porosisin.';

  @override
  String get apiPublicShopCopy => 'Kopjo linkun e dyqanit';

  @override
  String get apiLinkCopied => 'Linku u kopjua';

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

  @override
  String get businessesSectionTitle => 'Dyqanet e tua';

  @override
  String businessesSectionSubtitle(
    int maxBusinesses,
    String planTitle,
    int maxProducts,
  ) {
    return 'Një llogari · deri në $maxBusinesses dyqane në planin $planTitle. Çdo dyqan ka katalog, porosi, oferta dhe API publike (deri $maxProducts produkte për dyqan).';
  }

  @override
  String businessesQuotaUsage(int owned, int max) {
    return '$owned nga $max dyqane';
  }

  @override
  String businessesAddStore(int next, int max) {
    return 'Shto dyqan ($next/$max)';
  }

  @override
  String businessesAddStoreFull(int owned, int max) {
    return 'Shto dyqan tjetër ($owned/$max)';
  }

  @override
  String businessesLimitReached(int max, String planCode) {
    return 'Ke arritur limitin $max dyqane në planin $planCode. Ngritu planin te Cilësimet.';
  }

  @override
  String get businessesEmpty =>
      'Ende pa dyqan. Krijo dyqanin të parë e-commerce më poshtë.';

  @override
  String get businessTileActive => 'Aktiv tani';

  @override
  String get businessTileSwitch => 'Hap';

  @override
  String businessTileApiSlug(String slug) {
    return 'URL dyqani: $slug';
  }

  @override
  String get businessTileHint => 'Produkte, porosi & API të veçanta';

  @override
  String get createFirstStoreTitle => 'Krijo dyqanin të parë';

  @override
  String get createFirstStoreBody =>
      'Çdo dyqan është një hapësirë e plotë e-commerce: produkte, kategori, oferta dhe API publike për web/app. Mbetesh me të njëjtën llogari — shton dyqane të tjera kur të duash (çdo dyqan i ri faturohet veçmas).';

  @override
  String get createFirstStoreButton => 'Krijo dyqanin e parë';

  @override
  String createStoreDialogTitle(int next, int max) {
    return 'Dyqan i ri ($next nga $max)';
  }

  @override
  String createStoreDialogIntro(String price) {
    return 'Çdo dyqan i ri kërkon aktivizim një herë ($price, përfshin muajin e parë). Fatura ruhet në këtë llogari.';
  }

  @override
  String get createStoreContinuePayment => 'Vazhdo te pagesa';

  @override
  String createStoreQuotaSnack(int max) {
    return 'Limiti i dyqaneve ($max në planin tënd).';
  }

  @override
  String get createStoreSuccess => 'Dyqani u krijua · fatura u ruajt';

  @override
  String get switcherCreateStore => 'Krijo dyqan';

  @override
  String switcherMenuCreateStore(int owned, int max) {
    return 'Shto dyqan ($owned/$max)';
  }

  @override
  String get switcherTooltip => 'Dyqani aktiv — ndërro ose shto';

  @override
  String activeStoreBanner(String name) {
    return 'Po menaxhon: $name';
  }

  @override
  String get activeStoreBannerHint =>
      'Paneli, produktet dhe porositë janë vetëm për këtë dyqan.';

  @override
  String get activeStoreBannerManage => 'Të gjitha dyqanet';

  @override
  String get editProduct => 'Ndrysho produktin';

  @override
  String get saveProduct => 'Ruaj produktin';

  @override
  String get coreDetails => 'Detajet kryesore';

  @override
  String get productNameLabel => 'Emri *';

  @override
  String get productDescriptionLabel => 'Përshkrimi';

  @override
  String get productPriceLabel => 'Çmimi';

  @override
  String get productCategoryLabel => 'Kategoria';

  @override
  String get selectOption => 'Zgjidh';

  @override
  String get productActiveLabel => 'Aktiv';

  @override
  String get customFieldsSection => 'Fushat e personalizuara';

  @override
  String couldNotLoadCustomFields(String message) {
    return 'Nuk u ngarkuan fushat: $message';
  }

  @override
  String get productSaved => 'Produkti u ruajt';

  @override
  String get productUpdated => 'Produkti u përditësua';

  @override
  String get productDeleted => 'Produkti u fshi';

  @override
  String get deleteProductTitle => 'Fshi produktin';

  @override
  String deleteProductMessage(String name) {
    return 'Fshi \"$name\"? Ky veprim nuk kthehet mbrapsht.';
  }

  @override
  String productLimitReached(String usage) {
    return 'Limiti i produkteve ($usage). Ngritu planin te Cilësimet.';
  }

  @override
  String get productImageInvalidUrl =>
      'URL e pavlefshme. Ngarko përsëri ose përdor https publik.';

  @override
  String get productImagesTitle => 'Fotot e produktit';

  @override
  String productImagesSubtitle(int max) {
    return 'Deri në $max foto. Vetëm ato aktive shfaqen në dyqanin online.';
  }

  @override
  String productImagesMax(int max) {
    return 'Maksimumi $max foto për produkt.';
  }

  @override
  String get productImagesActive => 'Aktive';

  @override
  String get productImagesAddUrl => 'Shto URL';

  @override
  String get variantsSectionTitle => 'Variantet';

  @override
  String get variantsSectionSubtitle =>
      'Përdor fusha Select si akse (p.sh. Madhësia, Ngjyra), pastaj gjenero rreshta SKU me çmim dhe stok.';

  @override
  String get variantsSelectAxes => 'Akset e variantit';

  @override
  String get variantsGenerate => 'Gjenero kombinimet';

  @override
  String get variantsSku => 'SKU';

  @override
  String get variantsPrice => 'Çmimi';

  @override
  String get variantsQuantity => 'Sasia';

  @override
  String get variantsNoAxes =>
      'Shto fusha Select me opsione te Fushat e personalizuara (p.sh. Madhësia, Ngjyra).';

  @override
  String get variantsApplyBasePrice => 'Apliko çmimin bazë te të gjitha';

  @override
  String get variantsClear => 'Pastro variantet';

  @override
  String variantsRowLabel(String labels) {
    return '$labels';
  }

  @override
  String get saveField => 'Ruaj fushën';

  @override
  String get fieldLabel => 'Etiketa';

  @override
  String get fieldKey => 'Çelësi (Key)';

  @override
  String get fieldType => 'Lloji';

  @override
  String get fieldRequired => 'E detyrueshme në produkte';

  @override
  String get fieldActive => 'Aktive';

  @override
  String get fieldOptionsHint => 'Opsionet (një për rresht)';

  @override
  String get attrTypeText => 'Tekst (i shkurtër)';

  @override
  String get attrTypeTextarea => 'Tekst (i gjatë)';

  @override
  String get attrTypeNumber => 'Numër';

  @override
  String get attrTypeSelect => 'Zgjedhje';

  @override
  String get attrTypeMultiSelect => 'Zgjedhje shumëfishe';

  @override
  String get attrTypeColor => 'Ngjyrë';

  @override
  String get attrTypeBoolean => 'Po/Jo';

  @override
  String get defaultFieldsTitle => 'Fushat e paracaktuara';

  @override
  String get defaultFieldsSubtitle =>
      'Fushat e aktivizuara janë të detyrueshme kur shton produkt.';

  @override
  String get businessNameLabel => 'Emri i biznesit *';

  @override
  String get businessTypeLabel => 'Lloji i biznesit *';

  @override
  String get businessTypeSelect => 'Zgjidhni llojin';

  @override
  String get businessTypeRequired => 'Zgjidhni llojin e biznesit.';

  @override
  String get businessTypeRetail => 'Dyqan me pakicë';

  @override
  String get businessTypeFashion => 'Modë & aksesorë';

  @override
  String get businessTypeElectronics => 'Elektronikë & teknologji';

  @override
  String get businessTypeIt => 'IT & softuer';

  @override
  String get businessTypeDigitalAgency => 'Agjenci digjitale & marketing';

  @override
  String get businessTypeConstruction => 'Ndërtim & renovim';

  @override
  String get businessTypeRealEstate => 'Pasuri të paluajtshme';

  @override
  String get businessTypePhotography => 'Fotografi & video';

  @override
  String get businessTypeEvents => 'Evente & dasma';

  @override
  String get businessTypeLogistics => 'Transport & logjistikë';

  @override
  String get businessTypeAgriculture => 'Bujqësi & fermë';

  @override
  String get businessTypeGrocery => 'Market & ushqimore';

  @override
  String get businessTypeConvenienceStore => 'Market 24h / kiosk';

  @override
  String get businessTypeBakery => 'Furrë';

  @override
  String get businessTypePastry => 'Pastiçeri & torta';

  @override
  String get businessTypeWholesale => 'Shumicë / B2B';

  @override
  String get businessTypeRestaurant => 'Restorant';

  @override
  String get businessTypePizzeria => 'Piceri';

  @override
  String get businessTypeCafe => 'Kafene';

  @override
  String get businessTypeFastFood => 'Fast food & take away';

  @override
  String get businessTypeBar => 'Bar & lounge';

  @override
  String get businessTypeCatering => 'Catering & banak';

  @override
  String get businessTypeButcher => 'Qendër mishi / berati';

  @override
  String get businessTypeIceCream => 'Akullore & ëmbëlsira';

  @override
  String get businessTypeFlowerShop => 'Floristeri / lule';

  @override
  String get businessTypeJewelry => 'Argjendari & orë';

  @override
  String get businessTypeBookstore => 'Librari & shkollë';

  @override
  String get businessTypePharmacy => 'Farmaci & shëndet';

  @override
  String get businessTypePetShop => 'Dyqan kafshësh & grooming';

  @override
  String get businessTypeVeterinary => 'Veteriner / klinikë për kafshë';

  @override
  String get businessTypeServices => 'Shërbime të përgjithshme (termina)';

  @override
  String get businessTypeSalon => 'Sallon flokësh & bukurie';

  @override
  String get businessTypeSpa => 'Spa & wellness';

  @override
  String get businessTypeClinic => 'Klinikë & praktikë mjekësore';

  @override
  String get businessTypeDental => 'Stomatologji';

  @override
  String get businessTypeAutomotive => 'Servis & riparim automjeti';

  @override
  String get businessTypeFitness => 'Palestër & fitness';

  @override
  String get businessTypeEducation => 'Arsim & kurse/mësime';

  @override
  String get businessTypeProfessional =>
      'Shërbime profesionale (ligjore, kontabilitet…)';

  @override
  String get businessTypeHomeServices =>
      'Shërbime në shtëpi (hidraulik, pastrim…)';

  @override
  String get businessTypeHotel => 'Hotel & akomodim';

  @override
  String get businessTypeOther => 'Tjetër';

  @override
  String get businessSlugLabel => 'URL Slug *';

  @override
  String get businessSlugHelper =>
      'API publike: /api/public/slug-i-yt/products';

  @override
  String get internalSlugLabel => 'Slug i brendshëm *';

  @override
  String get internalSlugHint => 'elektronike';

  @override
  String get internalSlugHelper =>
      'Nuk përkthehet. Përdoret në API, lidhje dhe databazë (p.sh. elektronike, pica-pije).';

  @override
  String get internalSlugImmutableHelper =>
      'Slug-u i brendshëm nuk ndryshohet pas krijimit.';

  @override
  String get internalSlugImmutableNote =>
      'Slug-u mbetet i njëjtë për lidhje të qëndrueshme në API.';

  @override
  String get internalSlugTaken =>
      'Ky slug i brendshëm është tashmë në përdorim.';

  @override
  String get localizedContentSection => 'Përkthimet';

  @override
  String get localizedContentHelper =>
      'Kërkohet vetëm tab-i i gjuhës default. Përdor Auto translate për gjuhët e tjera.';

  @override
  String get autoTranslateButton => 'Auto translate';

  @override
  String get autoTranslateNeedSource =>
      'Plotëso emrin ose përshkrimin në gjuhën default fillimisht.';

  @override
  String get autoTranslateDone =>
      'Përkthimet u gjeneruan. Kontrollo para ruajtjes.';

  @override
  String get seoTitleLabel => 'Titulli SEO';

  @override
  String get seoDescriptionLabel => 'Përshkrimi SEO';

  @override
  String get localizedSlugsSection => 'Slug URL për dyqanin (opsionale)';

  @override
  String localizedSlugsHelper(String slug) {
    return 'Opsionale për gjuhë. Default përdor slug-un \"$slug\".';
  }

  @override
  String get businessCreatedInvoiceFailed =>
      'Dyqani u krijua, por fatura nuk u ruajt. Shiko Faturimin.';

  @override
  String get paymentTitle => 'Përfundo pagesën';

  @override
  String paymentSubtitleRegistration(String plan) {
    return 'Binisoft Admin · plani $plan';
  }

  @override
  String paymentSubtitleNewBusiness(String name) {
    return 'Dyqan i ri · $name';
  }

  @override
  String paymentPayRegistration(String amount) {
    return 'Paguaj $amount dhe krijo llogarinë';
  }

  @override
  String paymentPayNewBusiness(String amount) {
    return 'Paguaj $amount dhe krijo dyqanin';
  }

  @override
  String get paymentDemoBannerRegistration =>
      'Modalitet demo: pa pagesë reale. Konfirmo për të krijuar llogarinë.';

  @override
  String get paymentDemoBannerNewBusiness =>
      'Modalitet demo: pa pagesë reale. Konfirmo për të aktivizuar dyqanin.';

  @override
  String get paymentActivationRegistration =>
      'Regjistrimi (përfshin muajin e 1-rë)';

  @override
  String get paymentActivationNewBusiness =>
      'Aktivizimi i dyqanit (përfshin muajin e 1-rë)';

  @override
  String get paymentMethod => 'Metoda e pagesës';

  @override
  String get paymentCard => 'Kartë';

  @override
  String get paymentPaypal => 'PayPal';

  @override
  String get paymentAcceptTerms =>
      'Pranoj kushtet e abonimit dhe tarifën mujore pas muajit të parë.';

  @override
  String get paymentAcceptTermsRequired => 'Prano kushtet për të vazhduar.';

  @override
  String get paymentInvalidCard => 'Vendos një numër karte të vlefshëm.';

  @override
  String get paymentCancel => 'Anulo';

  @override
  String get planChooseTitle => 'Zgjidh planin';

  @override
  String planChooseSubtitle(int max) {
    return '€30 + €6/muaj për 100 produkte (muaji 1 në regjistrim). Max $max produkte për dyqan.';
  }

  @override
  String get planBillingSoon =>
      'Faturimi së shpejti. Limitet vlejnë menjëherë pas përditësimit.';

  @override
  String get planBillingLater =>
      'Regjistrohu tani me limitet e planit. Faturimi aktivizohet më vonë.';

  @override
  String planPerMonth(String price) {
    return '$price/muaj pas muajit të 1-rë';
  }

  @override
  String planRegistration(String price) {
    return 'Regjistrimi $price (përfshin muajin e 1-rë)';
  }

  @override
  String get paymentThenMonthly => 'Pastaj mujore';

  @override
  String get paymentTotalDueToday => 'Totali sot';

  @override
  String planProductsCount(String title, int count) {
    return '$title · $count produkte';
  }

  @override
  String get defaultFieldRequired => '· e detyrueshme';

  @override
  String get teamSectionTitle => 'Ekipi & rolet';

  @override
  String get teamSectionSubtitle =>
      'Fto menaxher ose punonjës me email — ndaj kodin e ftesës që të regjistrohen te Bashkohu me ekipin.';

  @override
  String get teamInviteEmail => 'Email';

  @override
  String get teamInviteRole => 'Roli';

  @override
  String get teamInviteButton => 'Fto anëtar';

  @override
  String get teamEmpty => 'Ende pa ekip.';

  @override
  String get teamRemoveTitle => 'Hiq anëtarin?';

  @override
  String get teamRemoveMessage => 'Humbin aksesin në këtë dyqan.';

  @override
  String get teamRemoveConfirm => 'Hiq';

  @override
  String get teamRemoved => 'Anëtari u hoq';

  @override
  String get teamInviteAssigned =>
      'Anëtari u shtua — mund të hyjë me llogarinë ekzistuese.';

  @override
  String teamInviteCreated(String code) {
    return 'Kodi i ftesës: $code — ndaje dhe regjistrohu te Bashkohu me ekipin.';
  }

  @override
  String teamInviteCreatedCopied(String code) {
    return 'Kodi u kopjua: $code — ndaje; regjistrohu te Bashkohu me ekipin.';
  }

  @override
  String get tryAgain => 'Provo përsëri';

  @override
  String routerPageNotFound(String path) {
    return 'Faqja nuk u gjet: $path\n\nHap: …/binisoft-ad/#/login';
  }

  @override
  String get roleSuperadmin => 'Superadmin';

  @override
  String get roleOwner => 'Pronar';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleManager => 'Menaxher';

  @override
  String get roleEmployee => 'Punonjës';

  @override
  String get joinTeamTitle => 'Bashkohu me ekipin';

  @override
  String get joinTeamSubtitle =>
      'Përdor kodin nga pronari i dyqanit. Pa pagesë abonimi.';

  @override
  String get inviteCodeLabel => 'Kodi i ftesës';

  @override
  String get joinTeamButton => 'Krijo llogari & bashkohu';

  @override
  String joinTeamSuccess(String store) {
    return 'Mirë se erdhe! U lidhe me $store.';
  }

  @override
  String get haveAccountLogin => 'Ke llogari? Kyçu';

  @override
  String get loginJoinTeam => 'Bashkohu me kod ftese';
}
