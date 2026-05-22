// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Business Dashboard';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Orders';

  @override
  String get navAppointments => 'Appointments / Reservations';

  @override
  String get navReports => 'Reports';

  @override
  String get navBusinesses => 'Businesses';

  @override
  String get navProducts => 'Products';

  @override
  String get navOffers => 'Offers';

  @override
  String get navContests => 'Giveaways';

  @override
  String get navJobOpenings => 'Job openings';

  @override
  String get navCategories => 'Categories';

  @override
  String get navServices => 'Services';

  @override
  String get navCustomFields => 'Custom Fields';

  @override
  String get navApiDocs => 'API Docs';

  @override
  String get navSettings => 'Settings';

  @override
  String get navBilling => 'Billing & invoices';

  @override
  String get menuSignedInAs => 'Signed in as';

  @override
  String get menuCreateBusiness => 'Add store';

  @override
  String get menuLogOut => 'Log out';

  @override
  String get menuLanguage => 'App language';

  @override
  String get pageDashboardTitle => 'Dashboard';

  @override
  String get pageDashboardSubtitle => 'Overview of your product catalog';

  @override
  String get pageBusinessesTitle => 'Businesses';

  @override
  String get pageBusinessesSubtitle =>
      'One login manages separate stores. Switch the active store or add another (paid per activation).';

  @override
  String get pageProductsTitle => 'Products';

  @override
  String get pageProductsSubtitle => 'Manage your catalog entries.';

  @override
  String get pageOffersTitle => 'Offers';

  @override
  String get pageOffersSubtitle =>
      'Promotions with percent or sale price. Active offers apply on the public API and orders.';

  @override
  String get pageContestsTitle => 'Giveaways';

  @override
  String get pageContestsSubtitle =>
      'Prize draws and promotions (not hiring). Entries come from the shop — open the list with «Entries» on each card.';

  @override
  String get pageJobOpeningsTitle => 'Job openings';

  @override
  String get pageJobOpeningsSubtitle =>
      'Vacancies and recruitment — candidates apply via the public shop (name, phone, note).';

  @override
  String get pageCategoriesTitle => 'Categories';

  @override
  String get pageCategoriesSubtitle => 'Manage your product categories.';

  @override
  String get pageServicesTitle => 'Services';

  @override
  String get pageServicesSubtitle =>
      'Services your business offers (used for reservations and catalog).';

  @override
  String get serviceAddTitle => 'Add service';

  @override
  String get serviceEditTitle => 'Edit service';

  @override
  String get serviceSave => 'Save service';

  @override
  String get serviceName => 'Name';

  @override
  String get serviceDescription => 'Description';

  @override
  String get serviceDurationMinutes => 'Duration (minutes)';

  @override
  String get serviceDurationHint => 'e.g. 60';

  @override
  String get servicePriceEur => 'Price (€)';

  @override
  String get serviceActive => 'Active';

  @override
  String get servicesEmpty => 'No services yet. Add your first service.';

  @override
  String get serviceCreated => 'Service created';

  @override
  String get serviceUpdated => 'Service updated';

  @override
  String get serviceDeleted => 'Service deleted';

  @override
  String get appointmentServicePick => 'Select service';

  @override
  String get appointmentServiceCustom => 'Other (type manually)';

  @override
  String get pageCustomFieldsTitle => 'Custom Fields';

  @override
  String get pageCustomFieldsSubtitle => 'Define the schema for your products.';

  @override
  String get pageApiDocsTitle => 'API Documentation';

  @override
  String get pageApiDocsSubtitle =>
      'Public endpoints for your catalog (no auth required).';

  @override
  String get pageSettingsTitle => 'Settings';

  @override
  String get pageSettingsSubtitle =>
      'Manage your business profile, plan, and dashboard appearance.';

  @override
  String get pageBillingTitle => 'Billing & invoices';

  @override
  String get pageBillingSubtitle =>
      'Payment history grouped by month and year.';

  @override
  String get pageOrdersTitle => 'Orders';

  @override
  String get pageOrdersSubtitle => 'Manage incoming orders from your shop.';

  @override
  String get pageAppointmentsTitle => 'Appointments / Reservations';

  @override
  String get pageAppointmentsSubtitle =>
      'Manage reservations with client details, service type, and reminders.';

  @override
  String get appointmentAdd => 'New reservation';

  @override
  String get appointmentEditTitle => 'Edit reservation';

  @override
  String get appointmentFirstName => 'First name';

  @override
  String get appointmentLastName => 'Last name';

  @override
  String get appointmentFullName => 'Name';

  @override
  String get appointmentFirstNameRequired => 'First name is required';

  @override
  String get appointmentLastNameRequired => 'Last name is required';

  @override
  String get appointmentDescription => 'Description';

  @override
  String get appointmentDescriptionRequired => 'Description is required';

  @override
  String get appointmentServiceType => 'Service type';

  @override
  String get appointmentServiceTypeRequired => 'Service type is required';

  @override
  String get appointmentPhone => 'Phone number';

  @override
  String get appointmentPhoneRequired => 'Phone number is required';

  @override
  String get appointmentScheduledAt => 'Appointment time';

  @override
  String get appointmentCreatedAt => 'Created';

  @override
  String get appointmentReminder => 'Reminder';

  @override
  String get appointmentReminderNone => 'No reminder';

  @override
  String get appointmentReminder15 => '15 minutes before';

  @override
  String get appointmentReminder30 => '30 minutes before';

  @override
  String get appointmentReminder60 => '1 hour before';

  @override
  String get appointmentReminder120 => '2 hours before';

  @override
  String get appointmentReminder1440 => '1 day before';

  @override
  String get appointmentStatusScheduled => 'Scheduled';

  @override
  String get appointmentStatusCompleted => 'Completed';

  @override
  String get appointmentStatusCancelled => 'Cancelled';

  @override
  String get appointmentEmpty =>
      'No reservations yet. Create your first reservation.';

  @override
  String get appointmentEmptyDay => 'No reservations on this day.';

  @override
  String get appointmentTime => 'Time';

  @override
  String get appointmentCalendarToday => 'Today';

  @override
  String get appointmentCalendarPrevMonth => 'Previous month';

  @override
  String get appointmentCalendarNextMonth => 'Next month';

  @override
  String appointmentDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reservations this day',
      one: '1 reservation this day',
      zero: 'No reservations this day',
    );
    return '$_temp0';
  }

  @override
  String get appointmentSave => 'Save appointment';

  @override
  String get appointmentDeleteConfirm => 'Delete appointment?';

  @override
  String get appointmentMarkCompleted => 'Mark completed';

  @override
  String get appointmentMarkCancelled => 'Cancel appointment';

  @override
  String get appointmentReminderNotificationTitle => 'Appointment reminder';

  @override
  String appointmentReminderNotificationBody(
    String name,
    String serviceType,
    String when,
  ) {
    return '$name — $serviceType — $when';
  }

  @override
  String get searchAppointments => 'Search reservations…';

  @override
  String get pageReportsTitle => 'Reports';

  @override
  String get pageReportsSubtitle => 'Sales and order analytics.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceSubtitle =>
      'Dark mode shows your dashboard wallpaper. Light mode uses a clean glass look without background images.';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get apiLanguagesTitle => 'API languages';

  @override
  String get apiLanguagesSubtitle =>
      'Languages for your public shop API (?lang=). Product forms show only selected languages.';

  @override
  String get apiLanguagesSave => 'Save API languages';

  @override
  String get apiLanguagesSaved => 'API languages saved';

  @override
  String get apiLanguagesPickOne => 'Select at least one language for the API';

  @override
  String get apiLanguagesDefault => 'Default catalog language';

  @override
  String get apiLanguagesHint =>
      'Only the default language is required when adding products or categories. Other selected languages are optional.';

  @override
  String get localeSq => 'Albanian';

  @override
  String get localeEn => 'English';

  @override
  String get localeDe => 'German';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get exportContinue => 'Export';

  @override
  String get exportPickLanguageTitle => 'Export language';

  @override
  String get exportPickLanguageSubtitle =>
      'Choose the language for the PDF document.';

  @override
  String exportFailed(String message) {
    return 'Export failed: $message';
  }

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get sharePdf => 'Share PDF';

  @override
  String get close => 'Close';

  @override
  String get reportsExportTitle => 'Export reports';

  @override
  String get reportsExportSubtitle =>
      'Download or share a PDF for today, this week, month, or year.';

  @override
  String get reportsThisWeek => 'This week';

  @override
  String get reportsThisWeekSubtitle => 'Monday – today';

  @override
  String get reportsRevenue => 'Revenue';

  @override
  String get reportsOrders => 'Orders';

  @override
  String get reportsPending => 'Pending';

  @override
  String get reportsRevenueHint => 'Excl. cancelled';

  @override
  String get reportsOrderStatus => 'Order status';

  @override
  String get reportsOrderStatusSubtitle =>
      'Pending, completed, and cancelled this week';

  @override
  String get reportsProductsSold => 'Products sold';

  @override
  String get reportsProductsSoldSubtitle => 'From active and completed orders';

  @override
  String get reportsOrdersThisWeek => 'Orders this week';

  @override
  String get pageReportsSubtitleLong =>
      'Export PDFs and view sales for the current period.';

  @override
  String get loadingInvoices => 'Loading invoices…';

  @override
  String get noInvoicesYet => 'No invoices yet';

  @override
  String get noInvoicesHint =>
      'Invoices appear here after registration or monthly billing.';

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get invoiceAmount => 'Amount';

  @override
  String get invoiceType => 'Type';

  @override
  String get invoiceTypeSubscription => 'Subscription';

  @override
  String get invoiceTypeMonthly => 'Monthly payment';

  @override
  String get invoicePlan => 'Plan';

  @override
  String get invoicePaid => 'Paid';

  @override
  String get invoiceMethod => 'Method';

  @override
  String get invoiceDetails => 'Details';

  @override
  String invoicePlanProducts(String plan, int count) {
    return '$plan · up to $count products';
  }

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get periodDaily => 'Daily';

  @override
  String get periodWeekly => 'Weekly';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodYearly => 'Yearly';

  @override
  String get ordersTodayTitle => 'Orders today';

  @override
  String get ordersTodaySubtitle =>
      'Orders received today from your online shop.';

  @override
  String get ordersLatestTitle => 'Latest order';

  @override
  String get ordersLatestSubtitle => 'Most recent order from your shop.';

  @override
  String get ordersSearchHint => 'Search order #, customer, product…';

  @override
  String get tableOrder => 'Order';

  @override
  String get tableCustomer => 'Customer';

  @override
  String get tableProduct => 'Product';

  @override
  String get tableQty => 'Qty';

  @override
  String get tableTotal => 'Total';

  @override
  String get tableStatus => 'Status';

  @override
  String get tableDate => 'Date';

  @override
  String get ordersEmptyToday => 'No orders today yet.';

  @override
  String get ordersEmptyNone => 'No orders yet.';

  @override
  String get ordersEmptyConnect =>
      'No orders yet. Connect your shop with POST /orders (API Docs).';

  @override
  String get orderNoPhone => 'No phone number';

  @override
  String orderDialerFailed(String phone) {
    return 'Could not open phone dialer for $phone';
  }

  @override
  String get orderDetailCustomer => 'Customer';

  @override
  String get orderDetailProducts => 'Products';

  @override
  String get orderDetailTotal => 'Total';

  @override
  String get orderConfirm => 'Confirm order';

  @override
  String get recentOrdersTitle => 'Recent orders';

  @override
  String get recentOrdersSubtitle => 'Products ordered from your shop';

  @override
  String get seeAll => 'See all';

  @override
  String get viewAllOrders => 'View all orders';

  @override
  String get dashboardOrdersToday => 'Orders today';

  @override
  String get dashboardPendingOrders => 'Pending orders';

  @override
  String get dashboardSalesWeek => 'Sales this week';

  @override
  String get dashboardTotalProducts => 'Total Products';

  @override
  String get dashboardActiveProducts => 'Active Products';

  @override
  String get dashboardCategories => 'Categories';

  @override
  String get dashboardAppointmentsToday => 'Appointments today';

  @override
  String get dashboardUpcomingAppointments => 'Upcoming appointments';

  @override
  String get topProductsTitle => 'Top products this week';

  @override
  String get topProductsSubtitle => 'Quantity sold and revenue per product';

  @override
  String get topProductsColumnProduct => 'PRODUCT';

  @override
  String get topProductsColumnQty => 'QTY';

  @override
  String get topProductsColumnRevenue => 'REVENUE';

  @override
  String get productsByCategoryTitle => 'Products by Category';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryTemplatesTitle =>
      'Suggested categories for your business type';

  @override
  String get addProduct => 'Add Product';

  @override
  String get addField => 'Add Field';

  @override
  String get searchProducts => 'Search products…';

  @override
  String get filterAllCategories => 'All Categories';

  @override
  String get filterAll => 'All';

  @override
  String get productStatusActive => 'Active';

  @override
  String get productStatusDraft => 'Draft';

  @override
  String get productStatusArchived => 'Archived';

  @override
  String get tableImage => 'Image';

  @override
  String get tableName => 'Name';

  @override
  String get tableCategory => 'Category';

  @override
  String get tablePrice => 'Price';

  @override
  String get tableActions => 'Actions';

  @override
  String get tableDescription => 'Description';

  @override
  String get tableLabel => 'Label';

  @override
  String get tableKey => 'Name (Key)';

  @override
  String get tableType => 'Type';

  @override
  String get tableRequired => 'Required';

  @override
  String get productsEmpty => 'No products found.';

  @override
  String get categoriesEmpty => 'No categories found.';

  @override
  String get customFieldsAll => 'All fields';

  @override
  String get customFieldsEmpty => 'No custom fields defined.';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get settingsActiveBusinessTitle => 'Active business profile';

  @override
  String get settingsActiveBusinessSubtitle =>
      'Update your public-facing business details.';

  @override
  String get settingsPublicShopProfileTitle => 'Public shop profile';

  @override
  String get settingsPublicShopProfileSubtitle =>
      'Copy, logo, location and contact shown on your online shop. Layout (colors, sections) is in the site editor below.';

  @override
  String get settingsHeroTagline => 'Hero tagline';

  @override
  String get settingsHeroTaglineHint =>
      'Paragraph under your business name on the home section';

  @override
  String get settingsAboutBio => 'About us (bio)';

  @override
  String get settingsAboutBioHint => 'Full text for the About section';

  @override
  String get settingsOpeningHours => 'Opening hours';

  @override
  String get settingsOpeningHoursHint =>
      'e.g. Mon–Fri 9:00–22:00, Sat 10:00–23:00';

  @override
  String get siteEditorProfileHintHero =>
      'Name (H1), tagline and cover come from Public shop profile above — here you only toggle the section, menu label and optional hero image.';

  @override
  String get siteEditorProfileHintAbout =>
      'Fill here or use «About bio» in business profile — not the hero tagline.';

  @override
  String get siteSectionAboutBody => 'About section text';

  @override
  String get siteSectionAboutBodyHint => 'Full paragraph for this section';

  @override
  String get shopPreviewTitle => 'Shop preview';

  @override
  String get shopPreviewDraftNote =>
      'This preview uses your current form values — not saved yet. Use Save to publish to the live shop.';

  @override
  String get shopPreviewButton => 'Preview';

  @override
  String get shopPreviewOpenLive => 'Open live shop (saved)';

  @override
  String get shopPreviewSections => 'Sections on page';

  @override
  String get shopPreviewEmptyHint =>
      'Add name, tagline and contact for a richer preview.';

  @override
  String get settingsBusinessName => 'Business Name';

  @override
  String get settingsDescription => 'Description';

  @override
  String get settingsDescriptionHint => 'A brief description of your business';

  @override
  String get settingsLogoUrl => 'Logo URL';

  @override
  String get settingsCoverUrl => 'Shop cover image';

  @override
  String get settingsCoverNote =>
      'Displayed at the top of your public shop profile.';

  @override
  String get settingsBusinessType => 'Business type';

  @override
  String get settingsPostalCode => 'Postal code';

  @override
  String get settingsPostalCodeHint => 'e.g. 10000';

  @override
  String get settingsCity => 'City';

  @override
  String get settingsCityHint => 'e.g. Pristina';

  @override
  String get settingsState => 'Country / region';

  @override
  String get settingsStateHint => 'e.g. Kosovo';

  @override
  String get settingsLocationMaps => 'Location';

  @override
  String get settingsLocationMapsHint =>
      'https://maps.google.com/... or maps.app.goo.gl/...';

  @override
  String get settingsLocationMapsNote =>
      'Google Maps link (URL) only — Share from Maps. Do not paste iframe embed code.';

  @override
  String get settingsGoogleMapsUrlInvalid =>
      'Paste a valid Google Maps link (maps.google.com or maps.app.goo.gl).';

  @override
  String get settingsGoogleMapsNoIframe =>
      'Do not paste iframe HTML. In Google Maps use Share and copy the link (URL) only.';

  @override
  String get settingsWebsite => 'Website';

  @override
  String get websiteSectionTitle => 'Website';

  @override
  String get websiteSectionSubtitle =>
      'Add a public site for your store — self-service or custom with our team.';

  @override
  String get websiteChoosePlan => 'Choose how you want your website';

  @override
  String get websiteChoosePlanHint => 'Select an option above to continue.';

  @override
  String get websiteSimpleTitle => 'Simple site';

  @override
  String get websiteSimpleBadge => 'Included';

  @override
  String get websiteSimpleDescription =>
      'Ready-made shop page linked to your products, offers and WhatsApp orders.';

  @override
  String get websiteSimpleFeature1 =>
      'MARKET template with hero, products, offers, gallery';

  @override
  String get websiteSimpleFeature2 =>
      'Customize colors, sections and social links';

  @override
  String get websiteSimpleFeature3 =>
      'Live at kresha325.github.io/Binisoft-marketplace/your-slug';

  @override
  String get websiteProTitle => 'Professional website';

  @override
  String get websiteProBadge => 'Custom';

  @override
  String get websiteProDescription =>
      'Unique design, custom domain and advanced pages — built by Binisoft.';

  @override
  String get websiteProFeature1 => 'Custom layout and branding';

  @override
  String get websiteProFeature2 => 'Domain setup and SEO guidance';

  @override
  String get websiteProFeature3 => 'Dedicated support from our team';

  @override
  String get websiteSimpleSetupTitle => 'Generate your simple site';

  @override
  String get websiteSimpleSetupNote =>
      'Publish once, then fine-tune design in the section below.';

  @override
  String get websiteSimpleTemplateName =>
      'MARKET v1 — Hero, Offers, Products, About, Gallery, Contact';

  @override
  String get websiteGenerateSimple => 'Generate / publish site';

  @override
  String get websiteProContactTitle => 'Contact us for a professional site';

  @override
  String get websiteProContactBody =>
      'Tell us about your business and goals. We will reply with a quote and timeline.';

  @override
  String get websiteProContactButton => 'Email Binisoft';

  @override
  String get websiteProContactEmail => 'Or write to';

  @override
  String get websiteProRequested => 'Request sent';

  @override
  String get websiteTemplateLabel => 'Template';

  @override
  String get websiteLiveUrlLabel => 'Live URL';

  @override
  String get websiteOpenSite => 'Open site';

  @override
  String get websiteCopyLink => 'Copy link';

  @override
  String get websiteCustomDomainLabel => 'Custom domain (GoDaddy, etc.)';

  @override
  String get websiteCustomDomainNote =>
      'After deploy, point DNS (CNAME) to the platform host. SSL is enabled on Netlify/Firebase.';

  @override
  String get websiteDeployButton => 'Publish / refresh website';

  @override
  String get websiteDeploySuccess => 'Website published';

  @override
  String get websiteSlugRequired => 'Set a store URL slug first (Businesses).';

  @override
  String get websiteLastDeploy => 'Last publish';

  @override
  String get websiteDnsTitle => 'DNS records (add at your registrar)';

  @override
  String get websiteLinkCopied => 'Link copied';

  @override
  String get siteEditorTitle => 'Shop design';

  @override
  String get siteEditorSubtitle =>
      'Colors, enabled sections, gallery and social links — no duplicate text (that comes from profile above).';

  @override
  String get siteEditorColorsTitle => 'Colors';

  @override
  String get siteEditorColorPrimary => 'Primary (navy)';

  @override
  String get siteEditorColorAccent => 'Accent (yellow)';

  @override
  String get siteEditorColorBackground => 'Background';

  @override
  String get siteEditorColorText => 'Text';

  @override
  String get siteEditorLayoutLabel => 'Layout';

  @override
  String get siteEditorLayoutDefault => 'Default';

  @override
  String get siteEditorLayoutWide => 'Wide';

  @override
  String get siteEditorSectionsTitle => 'Sections';

  @override
  String get siteEditorSocialsTitle => 'Social networks';

  @override
  String get siteEditorFooterTitle => 'Footer';

  @override
  String get siteEditorFooterLocation => 'Show location';

  @override
  String get siteEditorFooterPhone => 'Show phone number';

  @override
  String get siteEditorFooterWhatsApp => 'Show WhatsApp button';

  @override
  String get siteEditorSaveButton => 'Save shop design';

  @override
  String get siteEditorSaved => 'Shop design saved';

  @override
  String get siteSectionEnabled => 'Visible on site';

  @override
  String get siteSectionDisabled => 'Hidden';

  @override
  String get siteSectionShowOnSite => 'Show this section';

  @override
  String get siteSectionNavLabel => 'Menu label (optional)';

  @override
  String get siteSectionTitle => 'Section title';

  @override
  String get siteSectionDescription => 'Description (optional)';

  @override
  String get siteSectionHero => 'Hero';

  @override
  String get siteSectionOffers => 'Offers';

  @override
  String get siteSectionProducts => 'Products';

  @override
  String get siteSectionServices => 'Services';

  @override
  String get siteSectionAbout => 'About us';

  @override
  String get siteSectionGallery => 'Gallery';

  @override
  String get siteSectionContact => 'Contact';

  @override
  String get siteSectionHeroH1 => 'Hero headline (H1)';

  @override
  String get siteSectionHeroP => 'Hero text (paragraph)';

  @override
  String get siteHeroUseProfileCover => 'Use profile cover image from settings';

  @override
  String get siteHeroImage => 'Hero background image';

  @override
  String siteGalleryHint(int max) {
    return 'Up to $max items — image and/or YouTube embed per slot.';
  }

  @override
  String get siteSectionCtaLabel => 'Primary button text';

  @override
  String get siteSectionSecondaryCtaLabel => 'Secondary button text';

  @override
  String get siteSectionTrustBullets => 'Trust bullets (hero)';

  @override
  String get siteSectionTrustBulletsHint => 'One line per bullet, up to 5.';

  @override
  String get siteCtaTargetLabel => 'Button goes to';

  @override
  String get siteCtaTargetProducts => 'Products';

  @override
  String get siteCtaTargetServices => 'Services';

  @override
  String get siteCtaTargetContact => 'Contact';

  @override
  String get siteCtaTargetOffers => 'Offers';

  @override
  String get siteCtaTargetWhatsapp => 'WhatsApp (open directly)';

  @override
  String get siteCtaTypeHint =>
      'Clinics and similar businesses should use “Book appointment” or “Contact us”, not “Order now”. Labels and actions are fully customizable.';

  @override
  String get siteCtaApplyTypeSuggestions =>
      'Apply suggestions for business type';

  @override
  String get siteGalleryAdd => 'Add gallery item';

  @override
  String get siteGalleryItem => 'Item';

  @override
  String get siteGalleryImage => 'Image';

  @override
  String get siteGalleryYoutube => 'YouTube URL (optional)';

  @override
  String get siteGalleryCaption => 'Caption (optional)';

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
  String get settingsShopCheckoutTitle => 'Online orders (cart)';

  @override
  String get settingsShopCheckoutSubtitle =>
      'Active options appear in the shop cart; inactive fields are hidden.';

  @override
  String get settingsShopCheckoutCart => 'Online cart';

  @override
  String get settingsShopCheckoutCartNote =>
      'Inactive: no “Add to cart”, no cart icon — catalog only.';

  @override
  String get settingsShopCheckoutName => 'Customer name';

  @override
  String get settingsShopCheckoutDelivery => 'Delivery address';

  @override
  String get settingsShopCheckoutDeliveryNote =>
      'Enable only if you deliver; customers must fill it in.';

  @override
  String get settingsShopCheckoutNotes => 'Order notes';

  @override
  String get settingsShopCheckoutPhone => 'Phone (optional)';

  @override
  String get settingsOrderPhone => 'Phone (calls & WhatsApp)';

  @override
  String get settingsContactEmail => 'Contact email';

  @override
  String get settingsContactEmailNote =>
      'Shown in the public Contact section — tap opens email.';

  @override
  String get subscriptionPlanTitle => 'Subscription plan';

  @override
  String get changePlan => 'Change plan';

  @override
  String get settingsOrderPhoneNote =>
      'Number for calls, WhatsApp, and checkout orders.';

  @override
  String get productsByCategoryEmpty =>
      'No products yet. Add products from the Products page.';

  @override
  String get offerAddTitle => 'Add offer';

  @override
  String get offerEditTitle => 'Edit offer';

  @override
  String get offerSave => 'Save offer';

  @override
  String get offerActive => 'Active';

  @override
  String offerDurationLabel(int days) {
    return 'Duration: $days days';
  }

  @override
  String get offerProductsLabel => 'Products in this offer';

  @override
  String get offerNoProducts => 'No active products. Add products first.';

  @override
  String get offerPickProducts => 'Select at least one product.';

  @override
  String get offerModePercent => '% off';

  @override
  String get offerModeSalePrice => 'Sale price';

  @override
  String get offerPercentLabel => 'Discount percent';

  @override
  String get offerSalePriceLabel => 'Sale price (EUR)';

  @override
  String get offerInvalidPercent => 'Enter a discount percent greater than 0.';

  @override
  String get offerInvalidPrice => 'Enter a valid sale price.';

  @override
  String get offersEmpty => 'No offers yet.';

  @override
  String get offerColumnProducts => 'Products';

  @override
  String get offerColumnDiscount => 'Discount';

  @override
  String get offerColumnPeriod => 'Period';

  @override
  String get offerStatusLive => 'Live';

  @override
  String get offerStatusScheduled => 'Scheduled';

  @override
  String get offerStatusExpired => 'Expired';

  @override
  String get searchOffers => 'Search offers…';

  @override
  String get offerSectionDetails => 'Core details';

  @override
  String get offerSectionDuration => 'Duration & visibility';

  @override
  String get offerRenewHint =>
      'Saving will start a new period from today (this offer has ended).';

  @override
  String get offerSaved => 'Offer saved';

  @override
  String offerSavedCount(int count) {
    return '$count offers saved';
  }

  @override
  String get offerSeparateSaveHint =>
      'Each selected product is saved as its own offer with its own title.';

  @override
  String get offerEditSplitHint =>
      'Saving will split this offer into separate offers — one product each.';

  @override
  String get offerEditProductsMissing =>
      'This offer\'s products were not found in the catalog (they may have been removed).';

  @override
  String get offerUpdated => 'Offer updated';

  @override
  String get offerDeleted => 'Offer deleted';

  @override
  String get offerDeleteTitle => 'Delete offer?';

  @override
  String offerDeleteMessage(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get offerDeleteConfirm => 'Delete';

  @override
  String offerSummaryPercent(double percent) {
    return '$percent% off';
  }

  @override
  String offerSummarySalePrice(double price) {
    return '€$price';
  }

  @override
  String get offerQuickTitleHint =>
      'Title is filled from selected products — you can edit it.';

  @override
  String get offerSearchProducts => 'Search products…';

  @override
  String offerResultPrice(String price) {
    return 'Offer price: €$price';
  }

  @override
  String get productPutOnOffer => 'Add to offer';

  @override
  String get productEditOffer => 'Edit offer';

  @override
  String productAlreadyOnOffer(String title) {
    return 'On offer: «$title»';
  }

  @override
  String get contestAddTitle => 'Add contest';

  @override
  String get contestEditTitle => 'Edit contest';

  @override
  String get contestSave => 'Save contest';

  @override
  String get contestActive => 'Active';

  @override
  String get contestTitleLabel => 'Contest title';

  @override
  String get contestTitleHint => 'e.g. Summer giveaway 2026';

  @override
  String get contestPrizeLabel => 'Prize';

  @override
  String get contestPrizeHint => 'e.g. Dinner for 2';

  @override
  String get contestDescriptionLabel => 'Description / how to enter';

  @override
  String get contestDescriptionHint => 'Steps for customers to participate';

  @override
  String get contestRulesLabel => 'Rules';

  @override
  String get contestRulesHint => 'Full terms and conditions';

  @override
  String get contestImageLabel => 'Promo image';

  @override
  String get contestPickImage => 'Choose image';

  @override
  String get contestSectionDuration => 'Duration & visibility';

  @override
  String contestDurationLabel(int days) {
    return 'Duration: $days days';
  }

  @override
  String get contestRenewHint =>
      'Saving starts a new period from today (contest has expired).';

  @override
  String get contestSaved => 'Contest saved';

  @override
  String get contestUpdated => 'Contest updated';

  @override
  String get contestDeleted => 'Contest deleted';

  @override
  String get contestDeleteTitle => 'Delete contest?';

  @override
  String contestDeleteMessage(String title) {
    return 'Delete \"$title\"? All entries will be removed.';
  }

  @override
  String get contestsEmpty => 'No contests yet.';

  @override
  String get contestStatusLive => 'Live';

  @override
  String get contestStatusScheduled => 'Scheduled';

  @override
  String get contestStatusExpired => 'Expired';

  @override
  String get searchContests => 'Search contests…';

  @override
  String contestEntryCount(int n) {
    return '$n entries';
  }

  @override
  String get contestViewEntries => 'Entries';

  @override
  String contestEntriesTitle(String title) {
    return 'Entries — $title';
  }

  @override
  String get contestEntriesEmpty => 'No entries yet.';

  @override
  String get jobAddTitle => 'Add job opening';

  @override
  String get jobEditTitle => 'Edit job opening';

  @override
  String get jobSave => 'Save job opening';

  @override
  String get jobActive => 'Active';

  @override
  String get jobTitleLabel => 'Job title';

  @override
  String get jobTitleHint => 'e.g. Waiter / Line cook';

  @override
  String get jobLocationLabel => 'Location';

  @override
  String get jobLocationHint => 'e.g. City center';

  @override
  String get jobEmploymentTypeLabel => 'Employment type';

  @override
  String get jobEmploymentUnset => '— Select —';

  @override
  String get jobEmploymentFullTime => 'Full-time';

  @override
  String get jobEmploymentPartTime => 'Part-time';

  @override
  String get jobEmploymentContract => 'Contract';

  @override
  String get jobEmploymentInternship => 'Internship';

  @override
  String get jobEmploymentTemporary => 'Temporary';

  @override
  String get jobEmploymentOther => 'Other';

  @override
  String get jobDescriptionLabel => 'Job description';

  @override
  String get jobDescriptionHint => 'Role and benefits';

  @override
  String get jobRequirementsLabel => 'Requirements';

  @override
  String get jobRequirementsHint => 'Experience, documents, skills';

  @override
  String get jobSalaryLabel => 'Salary (optional)';

  @override
  String get jobSalaryHint => 'e.g. €400–500 / month';

  @override
  String get jobApplyEmailLabel => 'Apply by email';

  @override
  String get jobApplyEmailHint => 'hr@business.com';

  @override
  String get jobApplyUrlLabel => 'Apply URL';

  @override
  String get jobApplyUrlHint => 'https://…';

  @override
  String get jobImageLabel => 'Photo / banner';

  @override
  String get jobPickImage => 'Choose image';

  @override
  String get jobSectionDuration => 'Application period';

  @override
  String jobDurationLabel(int days) {
    return 'Duration: $days days';
  }

  @override
  String get jobRenewHint =>
      'Saving starts a new period from today (listing has expired).';

  @override
  String get jobSaved => 'Job opening saved';

  @override
  String get jobUpdated => 'Job opening updated';

  @override
  String get jobDeleted => 'Job opening deleted';

  @override
  String get jobDeleteTitle => 'Delete job opening?';

  @override
  String jobDeleteMessage(String title) {
    return 'Delete \"$title\"? All applications will be removed.';
  }

  @override
  String get jobsEmpty => 'No job openings yet.';

  @override
  String get jobStatusLive => 'Accepting applications';

  @override
  String get jobStatusScheduled => 'Scheduled';

  @override
  String get jobStatusExpired => 'Closed';

  @override
  String get searchJobOpenings => 'Search job openings…';

  @override
  String jobApplicationCount(int n) {
    return '$n applications';
  }

  @override
  String get jobViewApplications => 'Applications';

  @override
  String jobApplicationsTitle(String title) {
    return 'Applications — $title';
  }

  @override
  String get jobApplicationsEmpty => 'No applications yet.';

  @override
  String get apiPublicShopTitle => 'Online shop (your store)';

  @override
  String get apiPublicShopSubtitle =>
      'Each business gets a public menu at this link. Generate an API key below, then open the shop once with ?key=… so customers can place orders.';

  @override
  String get apiPublicShopCopy => 'Copy shop link';

  @override
  String get apiLinkCopied => 'Link copied';

  @override
  String get apiLivePreview => 'Live preview';

  @override
  String get apiLivePreviewTap => 'Tap Preview on the products endpoint';

  @override
  String get apiLivePreviewLoading => 'Loading catalog preview…';

  @override
  String get apiLivePreviewEmpty => 'Select a business to load preview.';

  @override
  String get apiPreviewRefresh => 'Refresh preview';

  @override
  String get apiIntegrationInfo => 'Integration guide';

  @override
  String get apiIntegrationInfoTitle => 'Web shop integration';

  @override
  String get apiIntegrationGuideTitle => 'Web integration guide';

  @override
  String get apiIntegrationGuideSubtitle =>
      'How to connect your menu or e-commerce site to this API.';

  @override
  String get apiIntegrationReadFull => 'Read full guide';

  @override
  String get businessesSectionTitle => 'Your stores';

  @override
  String businessesSectionSubtitle(
    int maxBusinesses,
    String planTitle,
    int maxProducts,
  ) {
    return 'One account · up to $maxBusinesses stores on $planTitle. Each store has its own catalog, orders, offers, and public API (up to $maxProducts products per store).';
  }

  @override
  String businessesQuotaUsage(int owned, int max) {
    return '$owned of $max stores used';
  }

  @override
  String businessesAddStore(int next, int max) {
    return 'Add store ($next/$max)';
  }

  @override
  String businessesAddStoreFull(int owned, int max) {
    return 'Add another store ($owned/$max)';
  }

  @override
  String businessesLimitReached(int max, String planCode) {
    return 'You reached the limit of $max stores on your $planCode plan. Upgrade in Settings to add more.';
  }

  @override
  String get businessesEmpty =>
      'No stores yet. Create your first e-commerce store below.';

  @override
  String get businessTileActive => 'Active now';

  @override
  String get businessTileSwitch => 'Open';

  @override
  String businessTileApiSlug(String slug) {
    return 'Shop URL: $slug';
  }

  @override
  String get businessTileHint => 'Separate products, orders & API';

  @override
  String get createFirstStoreTitle => 'Create your first store';

  @override
  String get createFirstStoreBody =>
      'A store is a full e-commerce space: its own products, categories, offers, and public API for your website or app. You stay on one login — add more stores anytime (each extra store is billed separately).';

  @override
  String get createFirstStoreButton => 'Create first store';

  @override
  String createStoreDialogTitle(int next, int max) {
    return 'New store ($next of $max)';
  }

  @override
  String createStoreDialogIntro(String price) {
    return 'After you tap Create, payment opens ($price, first month included). Your ATK invoice is saved on this account.';
  }

  @override
  String get createStoreDialogAtkIntro =>
      'Enter the legal entity details for your invoice (ATK): legal name, NIPT, and address.';

  @override
  String get createStoreFiscalSectionTitle => 'Invoice details (ATK)';

  @override
  String get createStoreCreateButton => 'Create';

  @override
  String get businessLegalNameLabel => 'Legal entity name *';

  @override
  String get businessLegalNameHint => 'As registered with tax authority';

  @override
  String get businessLegalNameRequired => 'Legal name is required.';

  @override
  String get businessNiptLabel => 'NIPT *';

  @override
  String get businessNiptInvalid => 'NIPT is not valid.';

  @override
  String get businessFiscalAddressLabel => 'Fiscal address *';

  @override
  String get businessFiscalAddressHint => 'Street, city';

  @override
  String get businessFiscalAddressRequired => 'Fiscal address is required.';

  @override
  String get createStoreContinuePayment => 'Continue to payment';

  @override
  String createStoreQuotaSnack(int max) {
    return 'Store limit reached ($max on your plan).';
  }

  @override
  String get createStoreSuccess => 'Store created · invoice saved';

  @override
  String get switcherCreateStore => 'Create store';

  @override
  String switcherMenuCreateStore(int owned, int max) {
    return 'Add store ($owned/$max)';
  }

  @override
  String get switcherTooltip => 'Active store — switch or add another';

  @override
  String activeStoreBanner(String name) {
    return 'Managing: $name';
  }

  @override
  String get activeStoreBannerHint =>
      'Dashboard, products and orders apply to this store only.';

  @override
  String get activeStoreBannerManage => 'All stores';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get coreDetails => 'Core Details';

  @override
  String get productNameLabel => 'Name *';

  @override
  String get productDescriptionLabel => 'Description';

  @override
  String get productPriceLabel => 'Price';

  @override
  String get productCategoryLabel => 'Category';

  @override
  String get selectOption => 'Select';

  @override
  String get productActiveLabel => 'Active';

  @override
  String get customFieldsSection => 'Custom Fields';

  @override
  String couldNotLoadCustomFields(String message) {
    return 'Could not load custom fields: $message';
  }

  @override
  String get productSaved => 'Product saved';

  @override
  String get productUpdated => 'Product updated';

  @override
  String get productDeleted => 'Product deleted';

  @override
  String get deleteProductTitle => 'Delete product';

  @override
  String deleteProductMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String productLimitReached(String usage) {
    return 'Product limit reached ($usage). Upgrade your plan in Settings.';
  }

  @override
  String get productImageInvalidUrl =>
      'Invalid image URL. Upload the file again or use a public https URL.';

  @override
  String get productImagesTitle => 'Product photos';

  @override
  String productImagesSubtitle(int max) {
    return 'Up to $max images. Only active photos appear on your online shop.';
  }

  @override
  String productImagesMax(int max) {
    return 'Maximum $max photos per product.';
  }

  @override
  String get productImagesActive => 'Active';

  @override
  String get productImagesAddUrl => 'Add URL';

  @override
  String get variantsSectionTitle => 'Variants';

  @override
  String get variantsSectionSubtitle =>
      'Use select-type custom fields as axes (e.g. Size, Color), then generate SKU rows with price and stock.';

  @override
  String get variantsSelectAxes => 'Variant axes';

  @override
  String get variantsGenerate => 'Generate combinations';

  @override
  String get variantsSku => 'SKU';

  @override
  String get variantsPrice => 'Price';

  @override
  String get variantsQuantity => 'Qty';

  @override
  String get variantsNoAxes =>
      'Add select fields with options under Custom Fields (e.g. Size, Color) to enable variants.';

  @override
  String get variantsApplyBasePrice => 'Apply base price to all';

  @override
  String get variantsClear => 'Clear variants';

  @override
  String variantsRowLabel(String labels) {
    return '$labels';
  }

  @override
  String get saveField => 'Save Field';

  @override
  String get fieldLabel => 'Label';

  @override
  String get fieldKey => 'Key (Name)';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldRequired => 'Required on products';

  @override
  String get fieldActive => 'Active';

  @override
  String get fieldOptionsHint => 'Options (one per line)';

  @override
  String get attrTypeText => 'Text (Short)';

  @override
  String get attrTypeTextarea => 'Text (Long)';

  @override
  String get attrTypeNumber => 'Number';

  @override
  String get attrTypeSelect => 'Select';

  @override
  String get attrTypeMultiSelect => 'Multi Select';

  @override
  String get attrTypeColor => 'Color';

  @override
  String get attrTypeBoolean => 'Boolean';

  @override
  String get defaultFieldsTitle => 'Default fields';

  @override
  String get defaultFieldsSubtitle =>
      'Enabled fields are required when adding a product.';

  @override
  String get businessNameLabel => 'Business Name *';

  @override
  String get businessTypeLabel => 'Business type *';

  @override
  String get businessTypeSelect => 'Choose a type';

  @override
  String get businessTypeRequired => 'Please choose a business type.';

  @override
  String get businessTypeRetail => 'Retail store';

  @override
  String get businessTypeFashion => 'Fashion & accessories';

  @override
  String get businessTypeElectronics => 'Electronics & tech';

  @override
  String get businessTypeIt => 'IT & software';

  @override
  String get businessTypeDigitalAgency => 'Digital agency & marketing';

  @override
  String get businessTypeConstruction => 'Construction & renovation';

  @override
  String get businessTypeRealEstate => 'Real estate';

  @override
  String get businessTypePhotography => 'Photography & video';

  @override
  String get businessTypeEvents => 'Events & weddings';

  @override
  String get businessTypeLogistics => 'Transport & logistics';

  @override
  String get businessTypeAgriculture => 'Agriculture & farm';

  @override
  String get businessTypeGrocery => 'Grocery & supermarket';

  @override
  String get businessTypeConvenienceStore => '24/7 convenience store';

  @override
  String get businessTypeBakery => 'Bakery';

  @override
  String get businessTypePastry => 'Pastry shop & cakes';

  @override
  String get businessTypeWholesale => 'Wholesale / B2B';

  @override
  String get businessTypeRestaurant => 'Restaurant';

  @override
  String get businessTypePizzeria => 'Pizzeria';

  @override
  String get businessTypeCafe => 'Café';

  @override
  String get businessTypeFastFood => 'Fast food & takeaway';

  @override
  String get businessTypeBar => 'Bar & lounge';

  @override
  String get businessTypeCatering => 'Catering & banquets';

  @override
  String get businessTypeButcher => 'Butcher shop';

  @override
  String get businessTypeIceCream => 'Ice cream & desserts';

  @override
  String get businessTypeFlowerShop => 'Flower shop';

  @override
  String get businessTypeJewelry => 'Jewelry & watches';

  @override
  String get businessTypeBookstore => 'Bookstore & stationery';

  @override
  String get businessTypePharmacy => 'Pharmacy & health';

  @override
  String get businessTypePetShop => 'Pet shop & grooming';

  @override
  String get businessTypeVeterinary => 'Veterinary clinic';

  @override
  String get businessTypeServices => 'General services (appointments)';

  @override
  String get businessTypeSalon => 'Hair salon & beauty';

  @override
  String get businessTypeSpa => 'Spa & wellness';

  @override
  String get businessTypeClinic => 'Clinic & medical practice';

  @override
  String get businessTypeDental => 'Dental practice';

  @override
  String get businessTypeAutomotive => 'Auto service & repair';

  @override
  String get businessTypeFitness => 'Gym & fitness studio';

  @override
  String get businessTypeEducation => 'Education & tutoring';

  @override
  String get businessTypeProfessional =>
      'Professional services (legal, accounting…)';

  @override
  String get businessTypeHomeServices => 'Home services (repairs, cleaning…)';

  @override
  String get businessTypeHotel => 'Hotel & accommodation';

  @override
  String get businessTypeOther => 'Other';

  @override
  String get businessSlugLabel => 'URL Slug *';

  @override
  String get businessSlugHelper =>
      'Public API path: /api/public/your-slug/products';

  @override
  String get internalSlugLabel => 'Internal slug *';

  @override
  String get internalSlugHint => 'electronics';

  @override
  String get internalSlugHelper =>
      'Not translated. Used in API, relations, and database (e.g. electronics, pizza-drinks).';

  @override
  String get internalSlugImmutableHelper =>
      'Internal slug cannot be changed after creation.';

  @override
  String get internalSlugImmutableNote =>
      'Slug is fixed for stable API links and relations.';

  @override
  String get internalSlugTaken => 'This internal slug is already in use.';

  @override
  String get localizedContentSection => 'Translations';

  @override
  String get localizedContentHelper =>
      'Only the default language tab is required. Use Auto translate to fill other languages from the default.';

  @override
  String get autoTranslateButton => 'Auto translate';

  @override
  String get autoTranslateNeedSource =>
      'Fill name or description in the default language first.';

  @override
  String get autoTranslateDone =>
      'Translations generated. Review before saving.';

  @override
  String get seoTitleLabel => 'SEO title';

  @override
  String get seoDescriptionLabel => 'SEO description';

  @override
  String get localizedSlugsSection => 'Localized shop URL slugs';

  @override
  String localizedSlugsHelper(String slug) {
    return 'Optional per language. Default uses internal slug \"$slug\".';
  }

  @override
  String get businessCreatedInvoiceFailed =>
      'Store created, but invoice could not be saved. Check Billing & invoices.';

  @override
  String get paymentTitle => 'Complete payment';

  @override
  String paymentSubtitleRegistration(String plan) {
    return 'Binisoft Admin · $plan plan';
  }

  @override
  String paymentSubtitleNewBusiness(String name) {
    return 'New store · $name';
  }

  @override
  String paymentPayRegistration(String amount) {
    return 'Pay $amount and create account';
  }

  @override
  String paymentPayNewBusiness(String amount) {
    return 'Pay $amount and create store';
  }

  @override
  String get paymentDemoBannerRegistration =>
      'Demo mode: no real charge yet. Confirm below to create your account.';

  @override
  String get paymentDemoBannerNewBusiness =>
      'Demo mode: no real charge yet. Confirm below to activate your new store.';

  @override
  String get paymentActivationRegistration =>
      'Registration (includes 1st month)';

  @override
  String get paymentActivationNewBusiness =>
      'Store activation (includes 1st month)';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentPaypal => 'PayPal';

  @override
  String get paymentAcceptTerms =>
      'I agree to the subscription terms and recurring monthly fee after the first month.';

  @override
  String get paymentAcceptTermsRequired =>
      'Please accept the terms to continue.';

  @override
  String get paymentInvalidCard => 'Enter a valid card number.';

  @override
  String get paymentCancel => 'Cancel';

  @override
  String get planChooseTitle => 'Choose your plan';

  @override
  String planChooseSubtitle(int max) {
    return '€30 + €6/month per 100 products (1st month included in registration). Max $max products per store.';
  }

  @override
  String get planBillingSoon =>
      'Billing integration coming soon. Limits apply immediately after update.';

  @override
  String get planBillingLater =>
      'You can register now and use your plan limits. Billing will be enabled later.';

  @override
  String planPerMonth(String price) {
    return '$price/mo after 1st month';
  }

  @override
  String planRegistration(String price) {
    return 'Registration $price (1st month incl.)';
  }

  @override
  String get paymentThenMonthly => 'Then monthly';

  @override
  String get paymentTotalDueToday => 'Total due today';

  @override
  String planProductsCount(String title, int count) {
    return '$title · $count products';
  }

  @override
  String get defaultFieldRequired => '· required';

  @override
  String get teamSectionTitle => 'Team & roles';

  @override
  String get teamSectionSubtitle =>
      'Invite managers (catalog + orders) or employees (orders only). Share the invite code — they register at Join team.';

  @override
  String get teamInviteEmail => 'Email';

  @override
  String get teamInviteRole => 'Role';

  @override
  String get teamInviteButton => 'Invite team member';

  @override
  String get teamEmpty => 'No team members yet.';

  @override
  String get teamRemoveTitle => 'Remove team member?';

  @override
  String get teamRemoveMessage => 'They will lose access to this store.';

  @override
  String get teamRemoveConfirm => 'Remove';

  @override
  String get teamRemoved => 'Team member removed';

  @override
  String get teamInviteAssigned =>
      'Team member added — they can sign in with their existing account.';

  @override
  String teamInviteCreated(String code) {
    return 'Invite code: $code — share it; they register at Join team.';
  }

  @override
  String teamInviteCreatedCopied(String code) {
    return 'Invite code copied: $code — share it; they register at Join team.';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String routerPageNotFound(String path) {
    return 'Page not found: $path\n\nOpen: …/binisoft-ad/#/login';
  }

  @override
  String get roleSuperadmin => 'Superadmin';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleEmployee => 'Employee';

  @override
  String get joinTeamTitle => 'Join a store team';

  @override
  String get joinTeamSubtitle =>
      'Use the invite code from your store owner. No subscription payment — team access only.';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get joinTeamButton => 'Create account & join';

  @override
  String joinTeamSuccess(String store) {
    return 'Welcome! You joined $store.';
  }

  @override
  String get haveAccountLogin => 'Already have an account? Sign in';

  @override
  String get loginJoinTeam => 'Join with invite code';

  @override
  String get navEmployees => 'Employees';

  @override
  String get pageEmployeesTitle => 'Employees';

  @override
  String get pageEmployeesSubtitle =>
      'Payroll list: name, contact, salary, pay day, and reminder before payday.';

  @override
  String get employeeAddTitle => 'Add employee';

  @override
  String get employeeEditTitle => 'Edit employee';

  @override
  String get employeeSave => 'Save employee';

  @override
  String get employeeFirstNameLabel => 'First name';

  @override
  String get employeeLastNameLabel => 'Last name';

  @override
  String get employeeEmailLabel => 'Email';

  @override
  String get employeeEmailHint => 'optional';

  @override
  String get employeePhoneLabel => 'Phone';

  @override
  String get employeePhoneHint => 'optional';

  @override
  String get employeeSalaryLabel => 'Salary (€)';

  @override
  String get employeeSalaryHint => 'e.g. 450';

  @override
  String get employeePhotoLabel => 'Photo';

  @override
  String get employeePickPhoto => 'Choose photo';

  @override
  String employeePaymentDayLabel(int day) {
    return 'Pay day: day $day of each month';
  }

  @override
  String get employeeReminderLabel => 'Payment reminder';

  @override
  String get employeeReminderNone => 'No reminder';

  @override
  String get employeeReminder1Day => '1 day before';

  @override
  String get employeeReminder3Days => '3 days before';

  @override
  String get employeeReminder7Days => '7 days before';

  @override
  String get employeeActiveLabel => 'Active in list';

  @override
  String get employeeActiveHint => 'Employee stays in the admin payroll list.';

  @override
  String get employeeShowOnSiteLabel => 'Show on shop page';

  @override
  String get employeeShowOnSiteHint =>
      'Visitors see them in the Team section (only when active).';

  @override
  String get employeeNameRequired => 'Enter first and last name.';

  @override
  String get employeeSalaryInvalid => 'Salary must be a valid number.';

  @override
  String get employeeCreated => 'Employee added';

  @override
  String get employeeUpdated => 'Employee updated';

  @override
  String get employeeDeleted => 'Employee removed';

  @override
  String get employeeDeleteTitle => 'Delete employee?';

  @override
  String employeeDeleteMessage(String name) {
    return 'Remove \"$name\" from the list?';
  }

  @override
  String get searchEmployees => 'Search employees…';

  @override
  String get employeesEmpty => 'No employees yet. Add the first one.';

  @override
  String get employeeOnSiteBadge => 'On site';

  @override
  String employeeReminderBadge(int days) {
    return '${days}d before';
  }

  @override
  String employeePayMeta(String amount, int day) {
    return '$amount · day $day';
  }

  @override
  String employeeNextPay(String date) {
    return 'Next pay: $date';
  }

  @override
  String get employeeReminderNotificationTitle => 'Payday reminder';

  @override
  String employeeReminderNotificationBody(
    String name,
    String amount,
    String date,
  ) {
    return '$name — pay $amount on $date.';
  }

  @override
  String get navMenu => 'More';

  @override
  String get storeLaunchChecklistTitle => 'Publish your store';

  @override
  String get storeLaunchChecklistSubtitle =>
      'Complete these steps for your public site (web and mobile).';

  @override
  String get storeLaunchTaskSlug => 'Store slug / URL';

  @override
  String get storeLaunchTaskLogo => 'Store logo';

  @override
  String get storeLaunchTaskCatalog => 'At least 1 active product or service';

  @override
  String get storeLaunchTaskContact => 'Contact phone or email';

  @override
  String get storeLaunchTaskPreview => 'Open your public store page';
}
