import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('sq'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments / Reservations'**
  String get navAppointments;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navBusinesses.
  ///
  /// In en, this message translates to:
  /// **'Businesses'**
  String get navBusinesses;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get navOffers;

  /// No description provided for @navContests.
  ///
  /// In en, this message translates to:
  /// **'Giveaways'**
  String get navContests;

  /// No description provided for @navJobOpenings.
  ///
  /// In en, this message translates to:
  /// **'Job openings'**
  String get navJobOpenings;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom Fields'**
  String get navCustomFields;

  /// No description provided for @navApiDocs.
  ///
  /// In en, this message translates to:
  /// **'API Docs'**
  String get navApiDocs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing & invoices'**
  String get navBilling;

  /// No description provided for @menuSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get menuSignedInAs;

  /// No description provided for @menuCreateBusiness.
  ///
  /// In en, this message translates to:
  /// **'Add store'**
  String get menuCreateBusiness;

  /// No description provided for @menuLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get menuLogOut;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get menuLanguage;

  /// No description provided for @pageDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get pageDashboardTitle;

  /// No description provided for @pageDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overview of your product catalog'**
  String get pageDashboardSubtitle;

  /// No description provided for @pageBusinessesTitle.
  ///
  /// In en, this message translates to:
  /// **'Businesses'**
  String get pageBusinessesTitle;

  /// No description provided for @pageBusinessesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One login manages separate stores. Switch the active store or add another (paid per activation).'**
  String get pageBusinessesSubtitle;

  /// No description provided for @pageProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get pageProductsTitle;

  /// No description provided for @pageProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your catalog entries.'**
  String get pageProductsSubtitle;

  /// No description provided for @pageOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get pageOffersTitle;

  /// No description provided for @pageOffersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Promotions with percent or sale price. Active offers apply on the public API and orders.'**
  String get pageOffersSubtitle;

  /// No description provided for @pageContestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Giveaways'**
  String get pageContestsTitle;

  /// No description provided for @pageContestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prize draws and promotions (not hiring). Entries come from the shop — open the list with «Entries» on each card.'**
  String get pageContestsSubtitle;

  /// No description provided for @pageJobOpeningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job openings'**
  String get pageJobOpeningsTitle;

  /// No description provided for @pageJobOpeningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vacancies and recruitment — candidates apply via the public shop (name, phone, note).'**
  String get pageJobOpeningsSubtitle;

  /// No description provided for @pageCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get pageCategoriesTitle;

  /// No description provided for @pageCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your product categories.'**
  String get pageCategoriesSubtitle;

  /// No description provided for @pageServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get pageServicesTitle;

  /// No description provided for @pageServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Services your business offers (used for reservations and catalog).'**
  String get pageServicesSubtitle;

  /// No description provided for @serviceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get serviceAddTitle;

  /// No description provided for @serviceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get serviceEditTitle;

  /// No description provided for @serviceSave.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get serviceSave;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get serviceName;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get serviceDescription;

  /// No description provided for @serviceDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get serviceDurationMinutes;

  /// No description provided for @serviceDurationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 60'**
  String get serviceDurationHint;

  /// No description provided for @servicePriceEur.
  ///
  /// In en, this message translates to:
  /// **'Price (€)'**
  String get servicePriceEur;

  /// No description provided for @serviceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get serviceActive;

  /// No description provided for @servicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services yet. Add your first service.'**
  String get servicesEmpty;

  /// No description provided for @serviceCreated.
  ///
  /// In en, this message translates to:
  /// **'Service created'**
  String get serviceCreated;

  /// No description provided for @serviceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service updated'**
  String get serviceUpdated;

  /// No description provided for @serviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Service deleted'**
  String get serviceDeleted;

  /// No description provided for @appointmentServicePick.
  ///
  /// In en, this message translates to:
  /// **'Select service'**
  String get appointmentServicePick;

  /// No description provided for @appointmentServiceCustom.
  ///
  /// In en, this message translates to:
  /// **'Other (type manually)'**
  String get appointmentServiceCustom;

  /// No description provided for @pageCustomFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Fields'**
  String get pageCustomFieldsTitle;

  /// No description provided for @pageCustomFieldsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Define the schema for your products.'**
  String get pageCustomFieldsSubtitle;

  /// No description provided for @pageApiDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'API Documentation'**
  String get pageApiDocsTitle;

  /// No description provided for @pageApiDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Public endpoints for your catalog (no auth required).'**
  String get pageApiDocsSubtitle;

  /// No description provided for @pageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pageSettingsTitle;

  /// No description provided for @pageSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your business profile, plan, and dashboard appearance.'**
  String get pageSettingsSubtitle;

  /// No description provided for @pageBillingTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing & invoices'**
  String get pageBillingTitle;

  /// No description provided for @pageBillingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment history grouped by month and year.'**
  String get pageBillingSubtitle;

  /// No description provided for @pageOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get pageOrdersTitle;

  /// No description provided for @pageOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage incoming orders from your shop.'**
  String get pageOrdersSubtitle;

  /// No description provided for @pageAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments / Reservations'**
  String get pageAppointmentsTitle;

  /// No description provided for @pageAppointmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage reservations with client details, service type, and reminders.'**
  String get pageAppointmentsSubtitle;

  /// No description provided for @appointmentAdd.
  ///
  /// In en, this message translates to:
  /// **'New reservation'**
  String get appointmentAdd;

  /// No description provided for @appointmentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit reservation'**
  String get appointmentEditTitle;

  /// No description provided for @appointmentFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get appointmentFirstName;

  /// No description provided for @appointmentLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get appointmentLastName;

  /// No description provided for @appointmentFullName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get appointmentFullName;

  /// No description provided for @appointmentFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get appointmentFirstNameRequired;

  /// No description provided for @appointmentLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get appointmentLastNameRequired;

  /// No description provided for @appointmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get appointmentDescription;

  /// No description provided for @appointmentDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get appointmentDescriptionRequired;

  /// No description provided for @appointmentServiceType.
  ///
  /// In en, this message translates to:
  /// **'Service type'**
  String get appointmentServiceType;

  /// No description provided for @appointmentServiceTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Service type is required'**
  String get appointmentServiceTypeRequired;

  /// No description provided for @appointmentPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get appointmentPhone;

  /// No description provided for @appointmentPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get appointmentPhoneRequired;

  /// No description provided for @appointmentScheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Appointment time'**
  String get appointmentScheduledAt;

  /// No description provided for @appointmentCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get appointmentCreatedAt;

  /// No description provided for @appointmentReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get appointmentReminder;

  /// No description provided for @appointmentReminderNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get appointmentReminderNone;

  /// No description provided for @appointmentReminder15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get appointmentReminder15;

  /// No description provided for @appointmentReminder30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes before'**
  String get appointmentReminder30;

  /// No description provided for @appointmentReminder60.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get appointmentReminder60;

  /// No description provided for @appointmentReminder120.
  ///
  /// In en, this message translates to:
  /// **'2 hours before'**
  String get appointmentReminder120;

  /// No description provided for @appointmentReminder1440.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get appointmentReminder1440;

  /// No description provided for @appointmentStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get appointmentStatusScheduled;

  /// No description provided for @appointmentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointmentStatusCompleted;

  /// No description provided for @appointmentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointmentStatusCancelled;

  /// No description provided for @appointmentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reservations yet. Create your first reservation.'**
  String get appointmentEmpty;

  /// No description provided for @appointmentEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'No reservations on this day.'**
  String get appointmentEmptyDay;

  /// No description provided for @appointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get appointmentTime;

  /// No description provided for @appointmentCalendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get appointmentCalendarToday;

  /// No description provided for @appointmentCalendarPrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get appointmentCalendarPrevMonth;

  /// No description provided for @appointmentCalendarNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get appointmentCalendarNextMonth;

  /// No description provided for @appointmentDayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reservations this day} =1{1 reservation this day} other{{count} reservations this day}}'**
  String appointmentDayCount(int count);

  /// No description provided for @appointmentSave.
  ///
  /// In en, this message translates to:
  /// **'Save appointment'**
  String get appointmentSave;

  /// No description provided for @appointmentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete appointment?'**
  String get appointmentDeleteConfirm;

  /// No description provided for @appointmentMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get appointmentMarkCompleted;

  /// No description provided for @appointmentMarkCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get appointmentMarkCancelled;

  /// No description provided for @appointmentReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminder'**
  String get appointmentReminderNotificationTitle;

  /// No description provided for @appointmentReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{name} — {serviceType} — {when}'**
  String appointmentReminderNotificationBody(
    String name,
    String serviceType,
    String when,
  );

  /// No description provided for @searchAppointments.
  ///
  /// In en, this message translates to:
  /// **'Search reservations…'**
  String get searchAppointments;

  /// No description provided for @pageReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get pageReportsTitle;

  /// No description provided for @pageReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sales and order analytics.'**
  String get pageReportsSubtitle;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode shows your dashboard wallpaper. Light mode uses a clean glass look without background images.'**
  String get appearanceSubtitle;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @apiLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'API languages'**
  String get apiLanguagesTitle;

  /// No description provided for @apiLanguagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Languages for your public shop API (?lang=). Product forms show only selected languages.'**
  String get apiLanguagesSubtitle;

  /// No description provided for @apiLanguagesSave.
  ///
  /// In en, this message translates to:
  /// **'Save API languages'**
  String get apiLanguagesSave;

  /// No description provided for @apiLanguagesSaved.
  ///
  /// In en, this message translates to:
  /// **'API languages saved'**
  String get apiLanguagesSaved;

  /// No description provided for @apiLanguagesPickOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one language for the API'**
  String get apiLanguagesPickOne;

  /// No description provided for @apiLanguagesDefault.
  ///
  /// In en, this message translates to:
  /// **'Default catalog language'**
  String get apiLanguagesDefault;

  /// No description provided for @apiLanguagesHint.
  ///
  /// In en, this message translates to:
  /// **'Only the default language is required when adding products or categories. Other selected languages are optional.'**
  String get apiLanguagesHint;

  /// No description provided for @localeSq.
  ///
  /// In en, this message translates to:
  /// **'Albanian'**
  String get localeSq;

  /// No description provided for @localeEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEn;

  /// No description provided for @localeDe.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get localeDe;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exportContinue.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportContinue;

  /// No description provided for @exportPickLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Export language'**
  String get exportPickLanguageTitle;

  /// No description provided for @exportPickLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language for the PDF document.'**
  String get exportPickLanguageSubtitle;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {message}'**
  String exportFailed(String message);

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdf;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reportsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export reports'**
  String get reportsExportTitle;

  /// No description provided for @reportsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download or share a PDF for today, this week, month, or year.'**
  String get reportsExportSubtitle;

  /// No description provided for @reportsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get reportsThisWeek;

  /// No description provided for @reportsThisWeekSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monday – today'**
  String get reportsThisWeekSubtitle;

  /// No description provided for @reportsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportsRevenue;

  /// No description provided for @reportsOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get reportsOrders;

  /// No description provided for @reportsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reportsPending;

  /// No description provided for @reportsRevenueHint.
  ///
  /// In en, this message translates to:
  /// **'Excl. cancelled'**
  String get reportsRevenueHint;

  /// No description provided for @reportsOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get reportsOrderStatus;

  /// No description provided for @reportsOrderStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pending, completed, and cancelled this week'**
  String get reportsOrderStatusSubtitle;

  /// No description provided for @reportsProductsSold.
  ///
  /// In en, this message translates to:
  /// **'Products sold'**
  String get reportsProductsSold;

  /// No description provided for @reportsProductsSoldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From active and completed orders'**
  String get reportsProductsSoldSubtitle;

  /// No description provided for @reportsOrdersThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Orders this week'**
  String get reportsOrdersThisWeek;

  /// No description provided for @pageReportsSubtitleLong.
  ///
  /// In en, this message translates to:
  /// **'Export PDFs and view sales for the current period.'**
  String get pageReportsSubtitleLong;

  /// No description provided for @loadingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Loading invoices…'**
  String get loadingInvoices;

  /// No description provided for @noInvoicesYet.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get noInvoicesYet;

  /// No description provided for @noInvoicesHint.
  ///
  /// In en, this message translates to:
  /// **'Invoices appear here after registration or monthly billing.'**
  String get noInvoicesHint;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceTitle;

  /// No description provided for @invoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get invoiceAmount;

  /// No description provided for @invoiceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get invoiceType;

  /// No description provided for @invoiceTypeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get invoiceTypeSubscription;

  /// No description provided for @invoiceTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get invoiceTypeMonthly;

  /// No description provided for @invoicePlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get invoicePlan;

  /// No description provided for @invoicePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoicePaid;

  /// No description provided for @invoiceMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get invoiceMethod;

  /// No description provided for @invoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get invoiceDetails;

  /// No description provided for @invoicePlanProducts.
  ///
  /// In en, this message translates to:
  /// **'{plan} · up to {count} products'**
  String invoicePlanProducts(String plan, int count);

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @periodDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get periodDaily;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get periodYearly;

  /// No description provided for @ordersTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders today'**
  String get ordersTodayTitle;

  /// No description provided for @ordersTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders received today from your online shop.'**
  String get ordersTodaySubtitle;

  /// No description provided for @ordersLatestTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest order'**
  String get ordersLatestTitle;

  /// No description provided for @ordersLatestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Most recent order from your shop.'**
  String get ordersLatestSubtitle;

  /// No description provided for @ordersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search order #, customer, product…'**
  String get ordersSearchHint;

  /// No description provided for @tableOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get tableOrder;

  /// No description provided for @tableCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get tableCustomer;

  /// No description provided for @tableProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get tableProduct;

  /// No description provided for @tableQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get tableQty;

  /// No description provided for @tableTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get tableTotal;

  /// No description provided for @tableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tableStatus;

  /// No description provided for @tableDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tableDate;

  /// No description provided for @ordersEmptyToday.
  ///
  /// In en, this message translates to:
  /// **'No orders today yet.'**
  String get ordersEmptyToday;

  /// No description provided for @ordersEmptyNone.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get ordersEmptyNone;

  /// No description provided for @ordersEmptyConnect.
  ///
  /// In en, this message translates to:
  /// **'No orders yet. Connect your shop with POST /orders (API Docs).'**
  String get ordersEmptyConnect;

  /// No description provided for @orderNoPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get orderNoPhone;

  /// No description provided for @orderDialerFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open phone dialer for {phone}'**
  String orderDialerFailed(String phone);

  /// No description provided for @orderDetailCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderDetailCustomer;

  /// No description provided for @orderDetailProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get orderDetailProducts;

  /// No description provided for @orderDetailTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderDetailTotal;

  /// No description provided for @orderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get orderConfirm;

  /// No description provided for @recentOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get recentOrdersTitle;

  /// No description provided for @recentOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products ordered from your shop'**
  String get recentOrdersSubtitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @viewAllOrders.
  ///
  /// In en, this message translates to:
  /// **'View all orders'**
  String get viewAllOrders;

  /// No description provided for @dashboardOrdersToday.
  ///
  /// In en, this message translates to:
  /// **'Orders today'**
  String get dashboardOrdersToday;

  /// No description provided for @dashboardPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending orders'**
  String get dashboardPendingOrders;

  /// No description provided for @dashboardSalesWeek.
  ///
  /// In en, this message translates to:
  /// **'Sales this week'**
  String get dashboardSalesWeek;

  /// No description provided for @dashboardTotalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get dashboardTotalProducts;

  /// No description provided for @dashboardActiveProducts.
  ///
  /// In en, this message translates to:
  /// **'Active Products'**
  String get dashboardActiveProducts;

  /// No description provided for @dashboardCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get dashboardCategories;

  /// No description provided for @dashboardAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'Appointments today'**
  String get dashboardAppointmentsToday;

  /// No description provided for @dashboardUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get dashboardUpcomingAppointments;

  /// No description provided for @topProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top products this week'**
  String get topProductsTitle;

  /// No description provided for @topProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quantity sold and revenue per product'**
  String get topProductsSubtitle;

  /// No description provided for @topProductsColumnProduct.
  ///
  /// In en, this message translates to:
  /// **'PRODUCT'**
  String get topProductsColumnProduct;

  /// No description provided for @topProductsColumnQty.
  ///
  /// In en, this message translates to:
  /// **'QTY'**
  String get topProductsColumnQty;

  /// No description provided for @topProductsColumnRevenue.
  ///
  /// In en, this message translates to:
  /// **'REVENUE'**
  String get topProductsColumnRevenue;

  /// No description provided for @productsByCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Products by Category'**
  String get productsByCategoryTitle;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @categoryTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested categories for your business type'**
  String get categoryTemplatesTitle;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get addField;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get searchProducts;

  /// No description provided for @filterAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get filterAllCategories;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @productStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get productStatusActive;

  /// No description provided for @productStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get productStatusDraft;

  /// No description provided for @productStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get productStatusArchived;

  /// No description provided for @tableImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get tableImage;

  /// No description provided for @tableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tableName;

  /// No description provided for @tableCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get tableCategory;

  /// No description provided for @tablePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get tablePrice;

  /// No description provided for @tableActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tableActions;

  /// No description provided for @tableDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tableDescription;

  /// No description provided for @tableLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get tableLabel;

  /// No description provided for @tableKey.
  ///
  /// In en, this message translates to:
  /// **'Name (Key)'**
  String get tableKey;

  /// No description provided for @tableType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tableType;

  /// No description provided for @tableRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get tableRequired;

  /// No description provided for @productsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products found.'**
  String get productsEmpty;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories found.'**
  String get categoriesEmpty;

  /// No description provided for @customFieldsAll.
  ///
  /// In en, this message translates to:
  /// **'All fields'**
  String get customFieldsAll;

  /// No description provided for @customFieldsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No custom fields defined.'**
  String get customFieldsEmpty;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @settingsActiveBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Active business profile'**
  String get settingsActiveBusinessTitle;

  /// No description provided for @settingsActiveBusinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your public-facing business details.'**
  String get settingsActiveBusinessSubtitle;

  /// No description provided for @settingsPublicShopProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Public shop profile'**
  String get settingsPublicShopProfileTitle;

  /// No description provided for @settingsPublicShopProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy, logo, location and contact shown on your online shop. Layout (colors, sections) is in the site editor below.'**
  String get settingsPublicShopProfileSubtitle;

  /// No description provided for @settingsHeroTagline.
  ///
  /// In en, this message translates to:
  /// **'Hero tagline'**
  String get settingsHeroTagline;

  /// No description provided for @settingsHeroTaglineHint.
  ///
  /// In en, this message translates to:
  /// **'Paragraph under your business name on the home section'**
  String get settingsHeroTaglineHint;

  /// No description provided for @settingsAboutBio.
  ///
  /// In en, this message translates to:
  /// **'About us (bio)'**
  String get settingsAboutBio;

  /// No description provided for @settingsAboutBioHint.
  ///
  /// In en, this message translates to:
  /// **'Full text for the About section'**
  String get settingsAboutBioHint;

  /// No description provided for @settingsOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get settingsOpeningHours;

  /// No description provided for @settingsOpeningHoursHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mon–Fri 9:00–22:00, Sat 10:00–23:00'**
  String get settingsOpeningHoursHint;

  /// No description provided for @siteEditorProfileHintHero.
  ///
  /// In en, this message translates to:
  /// **'Name (H1), tagline and cover come from Public shop profile above — here you only toggle the section, menu label and optional hero image.'**
  String get siteEditorProfileHintHero;

  /// No description provided for @siteEditorProfileHintAbout.
  ///
  /// In en, this message translates to:
  /// **'Fill here or use «About bio» in business profile — not the hero tagline.'**
  String get siteEditorProfileHintAbout;

  /// No description provided for @siteSectionAboutBody.
  ///
  /// In en, this message translates to:
  /// **'About section text'**
  String get siteSectionAboutBody;

  /// No description provided for @siteSectionAboutBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Full paragraph for this section'**
  String get siteSectionAboutBodyHint;

  /// No description provided for @shopPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop preview'**
  String get shopPreviewTitle;

  /// No description provided for @shopPreviewDraftNote.
  ///
  /// In en, this message translates to:
  /// **'This preview uses your current form values — not saved yet. Use Save to publish to the live shop.'**
  String get shopPreviewDraftNote;

  /// No description provided for @shopPreviewButton.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get shopPreviewButton;

  /// No description provided for @shopPreviewOpenLive.
  ///
  /// In en, this message translates to:
  /// **'Open live shop (saved)'**
  String get shopPreviewOpenLive;

  /// No description provided for @shopPreviewSections.
  ///
  /// In en, this message translates to:
  /// **'Sections on page'**
  String get shopPreviewSections;

  /// No description provided for @shopPreviewEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add name, tagline and contact for a richer preview.'**
  String get shopPreviewEmptyHint;

  /// No description provided for @settingsBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get settingsBusinessName;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get settingsDescription;

  /// No description provided for @settingsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'A brief description of your business'**
  String get settingsDescriptionHint;

  /// No description provided for @settingsLogoUrl.
  ///
  /// In en, this message translates to:
  /// **'Logo URL'**
  String get settingsLogoUrl;

  /// No description provided for @settingsCoverUrl.
  ///
  /// In en, this message translates to:
  /// **'Shop cover image'**
  String get settingsCoverUrl;

  /// No description provided for @settingsCoverNote.
  ///
  /// In en, this message translates to:
  /// **'Displayed at the top of your public shop profile.'**
  String get settingsCoverNote;

  /// No description provided for @settingsBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Business type'**
  String get settingsBusinessType;

  /// No description provided for @settingsPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get settingsPostalCode;

  /// No description provided for @settingsPostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10000'**
  String get settingsPostalCodeHint;

  /// No description provided for @settingsCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get settingsCity;

  /// No description provided for @settingsCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pristina'**
  String get settingsCityHint;

  /// No description provided for @settingsState.
  ///
  /// In en, this message translates to:
  /// **'Country / region'**
  String get settingsState;

  /// No description provided for @settingsStateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kosovo'**
  String get settingsStateHint;

  /// No description provided for @settingsLocationMaps.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingsLocationMaps;

  /// No description provided for @settingsLocationMapsHint.
  ///
  /// In en, this message translates to:
  /// **'https://maps.google.com/... or maps.app.goo.gl/...'**
  String get settingsLocationMapsHint;

  /// No description provided for @settingsLocationMapsNote.
  ///
  /// In en, this message translates to:
  /// **'Google Maps link (URL) only — Share from Maps. Do not paste iframe embed code.'**
  String get settingsLocationMapsNote;

  /// No description provided for @settingsGoogleMapsUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Paste a valid Google Maps link (maps.google.com or maps.app.goo.gl).'**
  String get settingsGoogleMapsUrlInvalid;

  /// No description provided for @settingsGoogleMapsNoIframe.
  ///
  /// In en, this message translates to:
  /// **'Do not paste iframe HTML. In Google Maps use Share and copy the link (URL) only.'**
  String get settingsGoogleMapsNoIframe;

  /// No description provided for @settingsWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get settingsWebsite;

  /// No description provided for @websiteSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteSectionTitle;

  /// No description provided for @websiteSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a public site for your store — self-service or custom with our team.'**
  String get websiteSectionSubtitle;

  /// No description provided for @websiteChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want your website'**
  String get websiteChoosePlan;

  /// No description provided for @websiteChoosePlanHint.
  ///
  /// In en, this message translates to:
  /// **'Select an option above to continue.'**
  String get websiteChoosePlanHint;

  /// No description provided for @websiteSimpleTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple site'**
  String get websiteSimpleTitle;

  /// No description provided for @websiteSimpleBadge.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get websiteSimpleBadge;

  /// No description provided for @websiteSimpleDescription.
  ///
  /// In en, this message translates to:
  /// **'Ready-made shop page linked to your products, offers and WhatsApp orders.'**
  String get websiteSimpleDescription;

  /// No description provided for @websiteSimpleFeature1.
  ///
  /// In en, this message translates to:
  /// **'MARKET template with hero, products, offers, gallery'**
  String get websiteSimpleFeature1;

  /// No description provided for @websiteSimpleFeature2.
  ///
  /// In en, this message translates to:
  /// **'Customize colors, sections and social links'**
  String get websiteSimpleFeature2;

  /// No description provided for @websiteSimpleFeature3.
  ///
  /// In en, this message translates to:
  /// **'Live at kresha325.github.io/Binisoft-marketplace/your-slug'**
  String get websiteSimpleFeature3;

  /// No description provided for @websiteProTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional website'**
  String get websiteProTitle;

  /// No description provided for @websiteProBadge.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get websiteProBadge;

  /// No description provided for @websiteProDescription.
  ///
  /// In en, this message translates to:
  /// **'Unique design, custom domain and advanced pages — built by Binisoft.'**
  String get websiteProDescription;

  /// No description provided for @websiteProFeature1.
  ///
  /// In en, this message translates to:
  /// **'Custom layout and branding'**
  String get websiteProFeature1;

  /// No description provided for @websiteProFeature2.
  ///
  /// In en, this message translates to:
  /// **'Domain setup and SEO guidance'**
  String get websiteProFeature2;

  /// No description provided for @websiteProFeature3.
  ///
  /// In en, this message translates to:
  /// **'Dedicated support from our team'**
  String get websiteProFeature3;

  /// No description provided for @websiteSimpleSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate your simple site'**
  String get websiteSimpleSetupTitle;

  /// No description provided for @websiteSimpleSetupNote.
  ///
  /// In en, this message translates to:
  /// **'Publish once, then fine-tune design in the section below.'**
  String get websiteSimpleSetupNote;

  /// No description provided for @websiteSimpleTemplateName.
  ///
  /// In en, this message translates to:
  /// **'MARKET v1 — Hero, Offers, Products, About, Gallery, Contact'**
  String get websiteSimpleTemplateName;

  /// No description provided for @websiteGenerateSimple.
  ///
  /// In en, this message translates to:
  /// **'Generate / publish site'**
  String get websiteGenerateSimple;

  /// No description provided for @websiteProContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us for a professional site'**
  String get websiteProContactTitle;

  /// No description provided for @websiteProContactBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your business and goals. We will reply with a quote and timeline.'**
  String get websiteProContactBody;

  /// No description provided for @websiteProContactButton.
  ///
  /// In en, this message translates to:
  /// **'Email Binisoft'**
  String get websiteProContactButton;

  /// No description provided for @websiteProContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Or write to'**
  String get websiteProContactEmail;

  /// No description provided for @websiteProRequested.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get websiteProRequested;

  /// No description provided for @websiteTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get websiteTemplateLabel;

  /// No description provided for @websiteLiveUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Live URL'**
  String get websiteLiveUrlLabel;

  /// No description provided for @websiteOpenSite.
  ///
  /// In en, this message translates to:
  /// **'Open site'**
  String get websiteOpenSite;

  /// No description provided for @websiteCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get websiteCopyLink;

  /// No description provided for @websiteCustomDomainLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom domain (GoDaddy, etc.)'**
  String get websiteCustomDomainLabel;

  /// No description provided for @websiteCustomDomainNote.
  ///
  /// In en, this message translates to:
  /// **'After deploy, point DNS (CNAME) to the platform host. SSL is enabled on Netlify/Firebase.'**
  String get websiteCustomDomainNote;

  /// No description provided for @websiteDeployButton.
  ///
  /// In en, this message translates to:
  /// **'Publish / refresh website'**
  String get websiteDeployButton;

  /// No description provided for @websiteDeploySuccess.
  ///
  /// In en, this message translates to:
  /// **'Website published'**
  String get websiteDeploySuccess;

  /// No description provided for @websiteSlugRequired.
  ///
  /// In en, this message translates to:
  /// **'Set a store URL slug first (Businesses).'**
  String get websiteSlugRequired;

  /// No description provided for @websiteLastDeploy.
  ///
  /// In en, this message translates to:
  /// **'Last publish'**
  String get websiteLastDeploy;

  /// No description provided for @websiteDnsTitle.
  ///
  /// In en, this message translates to:
  /// **'DNS records (add at your registrar)'**
  String get websiteDnsTitle;

  /// No description provided for @websiteLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get websiteLinkCopied;

  /// No description provided for @siteEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop design'**
  String get siteEditorTitle;

  /// No description provided for @siteEditorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Colors, enabled sections, gallery and social links — no duplicate text (that comes from profile above).'**
  String get siteEditorSubtitle;

  /// No description provided for @siteEditorColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get siteEditorColorsTitle;

  /// No description provided for @siteEditorColorPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary (navy)'**
  String get siteEditorColorPrimary;

  /// No description provided for @siteEditorColorAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent (yellow)'**
  String get siteEditorColorAccent;

  /// No description provided for @siteEditorColorBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get siteEditorColorBackground;

  /// No description provided for @siteEditorColorText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get siteEditorColorText;

  /// No description provided for @siteEditorLayoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get siteEditorLayoutLabel;

  /// No description provided for @siteEditorLayoutDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get siteEditorLayoutDefault;

  /// No description provided for @siteEditorLayoutWide.
  ///
  /// In en, this message translates to:
  /// **'Wide'**
  String get siteEditorLayoutWide;

  /// No description provided for @siteEditorSectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get siteEditorSectionsTitle;

  /// No description provided for @siteEditorSocialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Social networks'**
  String get siteEditorSocialsTitle;

  /// No description provided for @siteEditorFooterTitle.
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get siteEditorFooterTitle;

  /// No description provided for @siteEditorFooterLocation.
  ///
  /// In en, this message translates to:
  /// **'Show location'**
  String get siteEditorFooterLocation;

  /// No description provided for @siteEditorFooterPhone.
  ///
  /// In en, this message translates to:
  /// **'Show phone number'**
  String get siteEditorFooterPhone;

  /// No description provided for @siteEditorFooterWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Show WhatsApp button'**
  String get siteEditorFooterWhatsApp;

  /// No description provided for @siteEditorSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save shop design'**
  String get siteEditorSaveButton;

  /// No description provided for @siteEditorSaved.
  ///
  /// In en, this message translates to:
  /// **'Shop design saved'**
  String get siteEditorSaved;

  /// No description provided for @siteSectionEnabled.
  ///
  /// In en, this message translates to:
  /// **'Visible on site'**
  String get siteSectionEnabled;

  /// No description provided for @siteSectionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get siteSectionDisabled;

  /// No description provided for @siteSectionShowOnSite.
  ///
  /// In en, this message translates to:
  /// **'Show this section'**
  String get siteSectionShowOnSite;

  /// No description provided for @siteSectionNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Menu label (optional)'**
  String get siteSectionNavLabel;

  /// No description provided for @siteSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section title'**
  String get siteSectionTitle;

  /// No description provided for @siteSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get siteSectionDescription;

  /// No description provided for @siteSectionHero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get siteSectionHero;

  /// No description provided for @siteSectionOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get siteSectionOffers;

  /// No description provided for @siteSectionProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get siteSectionProducts;

  /// No description provided for @siteSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get siteSectionServices;

  /// No description provided for @siteSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get siteSectionAbout;

  /// No description provided for @siteSectionGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get siteSectionGallery;

  /// No description provided for @siteSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get siteSectionContact;

  /// No description provided for @siteSectionHeroH1.
  ///
  /// In en, this message translates to:
  /// **'Hero headline (H1)'**
  String get siteSectionHeroH1;

  /// No description provided for @siteSectionHeroP.
  ///
  /// In en, this message translates to:
  /// **'Hero text (paragraph)'**
  String get siteSectionHeroP;

  /// No description provided for @siteHeroUseProfileCover.
  ///
  /// In en, this message translates to:
  /// **'Use profile cover image from settings'**
  String get siteHeroUseProfileCover;

  /// No description provided for @siteHeroImage.
  ///
  /// In en, this message translates to:
  /// **'Hero background image'**
  String get siteHeroImage;

  /// No description provided for @siteGalleryHint.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} items — image and/or YouTube embed per slot.'**
  String siteGalleryHint(int max);

  /// No description provided for @siteSectionCtaLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary button text'**
  String get siteSectionCtaLabel;

  /// No description provided for @siteSectionSecondaryCtaLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary button text'**
  String get siteSectionSecondaryCtaLabel;

  /// No description provided for @siteSectionTrustBullets.
  ///
  /// In en, this message translates to:
  /// **'Trust bullets (hero)'**
  String get siteSectionTrustBullets;

  /// No description provided for @siteSectionTrustBulletsHint.
  ///
  /// In en, this message translates to:
  /// **'One line per bullet, up to 5.'**
  String get siteSectionTrustBulletsHint;

  /// No description provided for @siteCtaTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Button goes to'**
  String get siteCtaTargetLabel;

  /// No description provided for @siteCtaTargetProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get siteCtaTargetProducts;

  /// No description provided for @siteCtaTargetServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get siteCtaTargetServices;

  /// No description provided for @siteCtaTargetContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get siteCtaTargetContact;

  /// No description provided for @siteCtaTargetOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get siteCtaTargetOffers;

  /// No description provided for @siteCtaTargetWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp (open directly)'**
  String get siteCtaTargetWhatsapp;

  /// No description provided for @siteCtaTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Clinics and similar businesses should use “Book appointment” or “Contact us”, not “Order now”. Labels and actions are fully customizable.'**
  String get siteCtaTypeHint;

  /// No description provided for @siteCtaApplyTypeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Apply suggestions for business type'**
  String get siteCtaApplyTypeSuggestions;

  /// No description provided for @siteGalleryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add gallery item'**
  String get siteGalleryAdd;

  /// No description provided for @siteGalleryItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get siteGalleryItem;

  /// No description provided for @siteGalleryImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get siteGalleryImage;

  /// No description provided for @siteGalleryYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube URL (optional)'**
  String get siteGalleryYoutube;

  /// No description provided for @siteGalleryCaption.
  ///
  /// In en, this message translates to:
  /// **'Caption (optional)'**
  String get siteGalleryCaption;

  /// No description provided for @siteSocialFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get siteSocialFacebook;

  /// No description provided for @siteSocialInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get siteSocialInstagram;

  /// No description provided for @siteSocialTiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get siteSocialTiktok;

  /// No description provided for @siteSocialYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get siteSocialYoutube;

  /// No description provided for @siteSocialLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get siteSocialLinkedin;

  /// No description provided for @siteSocialX.
  ///
  /// In en, this message translates to:
  /// **'X (Twitter)'**
  String get siteSocialX;

  /// No description provided for @siteSocialWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get siteSocialWhatsapp;

  /// No description provided for @settingsShopCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Online orders (cart)'**
  String get settingsShopCheckoutTitle;

  /// No description provided for @settingsShopCheckoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active options appear in the shop cart; inactive fields are hidden.'**
  String get settingsShopCheckoutSubtitle;

  /// No description provided for @settingsShopCheckoutCart.
  ///
  /// In en, this message translates to:
  /// **'Online cart'**
  String get settingsShopCheckoutCart;

  /// No description provided for @settingsShopCheckoutCartNote.
  ///
  /// In en, this message translates to:
  /// **'Inactive: no “Add to cart”, no cart icon — catalog only.'**
  String get settingsShopCheckoutCartNote;

  /// No description provided for @settingsShopCheckoutName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get settingsShopCheckoutName;

  /// No description provided for @settingsShopCheckoutDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get settingsShopCheckoutDelivery;

  /// No description provided for @settingsShopCheckoutDeliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Enable only if you deliver; customers must fill it in.'**
  String get settingsShopCheckoutDeliveryNote;

  /// No description provided for @settingsShopCheckoutNotes.
  ///
  /// In en, this message translates to:
  /// **'Order notes'**
  String get settingsShopCheckoutNotes;

  /// No description provided for @settingsShopCheckoutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get settingsShopCheckoutPhone;

  /// No description provided for @settingsOrderPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone (calls & WhatsApp)'**
  String get settingsOrderPhone;

  /// No description provided for @settingsContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get settingsContactEmail;

  /// No description provided for @settingsContactEmailNote.
  ///
  /// In en, this message translates to:
  /// **'Shown in the public Contact section — tap opens email.'**
  String get settingsContactEmailNote;

  /// No description provided for @subscriptionPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription plan'**
  String get subscriptionPlanTitle;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get changePlan;

  /// No description provided for @settingsOrderPhoneNote.
  ///
  /// In en, this message translates to:
  /// **'Number for calls, WhatsApp, and checkout orders.'**
  String get settingsOrderPhoneNote;

  /// No description provided for @productsByCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add products from the Products page.'**
  String get productsByCategoryEmpty;

  /// No description provided for @offerAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add offer'**
  String get offerAddTitle;

  /// No description provided for @offerEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit offer'**
  String get offerEditTitle;

  /// No description provided for @offerSave.
  ///
  /// In en, this message translates to:
  /// **'Save offer'**
  String get offerSave;

  /// No description provided for @offerActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get offerActive;

  /// No description provided for @offerDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: {days} days'**
  String offerDurationLabel(int days);

  /// No description provided for @offerProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Products in this offer'**
  String get offerProductsLabel;

  /// No description provided for @offerNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No active products. Add products first.'**
  String get offerNoProducts;

  /// No description provided for @offerPickProducts.
  ///
  /// In en, this message translates to:
  /// **'Select at least one product.'**
  String get offerPickProducts;

  /// No description provided for @offerModePercent.
  ///
  /// In en, this message translates to:
  /// **'% off'**
  String get offerModePercent;

  /// No description provided for @offerModeSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get offerModeSalePrice;

  /// No description provided for @offerPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount percent'**
  String get offerPercentLabel;

  /// No description provided for @offerSalePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale price (EUR)'**
  String get offerSalePriceLabel;

  /// No description provided for @offerInvalidPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter a discount percent greater than 0.'**
  String get offerInvalidPercent;

  /// No description provided for @offerInvalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid sale price.'**
  String get offerInvalidPrice;

  /// No description provided for @offersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No offers yet.'**
  String get offersEmpty;

  /// No description provided for @offerColumnProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get offerColumnProducts;

  /// No description provided for @offerColumnDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get offerColumnDiscount;

  /// No description provided for @offerColumnPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get offerColumnPeriod;

  /// No description provided for @offerStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get offerStatusLive;

  /// No description provided for @offerStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get offerStatusScheduled;

  /// No description provided for @offerStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get offerStatusExpired;

  /// No description provided for @searchOffers.
  ///
  /// In en, this message translates to:
  /// **'Search offers…'**
  String get searchOffers;

  /// No description provided for @offerSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Core details'**
  String get offerSectionDetails;

  /// No description provided for @offerSectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration & visibility'**
  String get offerSectionDuration;

  /// No description provided for @offerRenewHint.
  ///
  /// In en, this message translates to:
  /// **'Saving will start a new period from today (this offer has ended).'**
  String get offerRenewHint;

  /// No description provided for @offerSaved.
  ///
  /// In en, this message translates to:
  /// **'Offer saved'**
  String get offerSaved;

  /// No description provided for @offerSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} offers saved'**
  String offerSavedCount(int count);

  /// No description provided for @offerSeparateSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Each selected product is saved as its own offer with its own title.'**
  String get offerSeparateSaveHint;

  /// No description provided for @offerEditSplitHint.
  ///
  /// In en, this message translates to:
  /// **'Saving will split this offer into separate offers — one product each.'**
  String get offerEditSplitHint;

  /// No description provided for @offerEditProductsMissing.
  ///
  /// In en, this message translates to:
  /// **'This offer\'s products were not found in the catalog (they may have been removed).'**
  String get offerEditProductsMissing;

  /// No description provided for @offerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Offer updated'**
  String get offerUpdated;

  /// No description provided for @offerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Offer deleted'**
  String get offerDeleted;

  /// No description provided for @offerDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete offer?'**
  String get offerDeleteTitle;

  /// No description provided for @offerDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String offerDeleteMessage(String title);

  /// No description provided for @offerDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get offerDeleteConfirm;

  /// No description provided for @offerSummaryPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String offerSummaryPercent(double percent);

  /// No description provided for @offerSummarySalePrice.
  ///
  /// In en, this message translates to:
  /// **'€{price}'**
  String offerSummarySalePrice(double price);

  /// No description provided for @offerQuickTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title is filled from selected products — you can edit it.'**
  String get offerQuickTitleHint;

  /// No description provided for @offerSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get offerSearchProducts;

  /// No description provided for @offerResultPrice.
  ///
  /// In en, this message translates to:
  /// **'Offer price: €{price}'**
  String offerResultPrice(String price);

  /// No description provided for @productPutOnOffer.
  ///
  /// In en, this message translates to:
  /// **'Add to offer'**
  String get productPutOnOffer;

  /// No description provided for @productEditOffer.
  ///
  /// In en, this message translates to:
  /// **'Edit offer'**
  String get productEditOffer;

  /// No description provided for @productAlreadyOnOffer.
  ///
  /// In en, this message translates to:
  /// **'On offer: «{title}»'**
  String productAlreadyOnOffer(String title);

  /// No description provided for @contestAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add contest'**
  String get contestAddTitle;

  /// No description provided for @contestEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit contest'**
  String get contestEditTitle;

  /// No description provided for @contestSave.
  ///
  /// In en, this message translates to:
  /// **'Save contest'**
  String get contestSave;

  /// No description provided for @contestActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get contestActive;

  /// No description provided for @contestTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Contest title'**
  String get contestTitleLabel;

  /// No description provided for @contestTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Summer giveaway 2026'**
  String get contestTitleHint;

  /// No description provided for @contestPrizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prize'**
  String get contestPrizeLabel;

  /// No description provided for @contestPrizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dinner for 2'**
  String get contestPrizeHint;

  /// No description provided for @contestDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description / how to enter'**
  String get contestDescriptionLabel;

  /// No description provided for @contestDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Steps for customers to participate'**
  String get contestDescriptionHint;

  /// No description provided for @contestRulesLabel.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get contestRulesLabel;

  /// No description provided for @contestRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Full terms and conditions'**
  String get contestRulesHint;

  /// No description provided for @contestImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo image'**
  String get contestImageLabel;

  /// No description provided for @contestPickImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get contestPickImage;

  /// No description provided for @contestSectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration & visibility'**
  String get contestSectionDuration;

  /// No description provided for @contestDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: {days} days'**
  String contestDurationLabel(int days);

  /// No description provided for @contestRenewHint.
  ///
  /// In en, this message translates to:
  /// **'Saving starts a new period from today (contest has expired).'**
  String get contestRenewHint;

  /// No description provided for @contestSaved.
  ///
  /// In en, this message translates to:
  /// **'Contest saved'**
  String get contestSaved;

  /// No description provided for @contestUpdated.
  ///
  /// In en, this message translates to:
  /// **'Contest updated'**
  String get contestUpdated;

  /// No description provided for @contestDeleted.
  ///
  /// In en, this message translates to:
  /// **'Contest deleted'**
  String get contestDeleted;

  /// No description provided for @contestDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete contest?'**
  String get contestDeleteTitle;

  /// No description provided for @contestDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? All entries will be removed.'**
  String contestDeleteMessage(String title);

  /// No description provided for @contestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contests yet.'**
  String get contestsEmpty;

  /// No description provided for @contestStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get contestStatusLive;

  /// No description provided for @contestStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get contestStatusScheduled;

  /// No description provided for @contestStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get contestStatusExpired;

  /// No description provided for @searchContests.
  ///
  /// In en, this message translates to:
  /// **'Search contests…'**
  String get searchContests;

  /// No description provided for @contestEntryCount.
  ///
  /// In en, this message translates to:
  /// **'{n} entries'**
  String contestEntryCount(int n);

  /// No description provided for @contestViewEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get contestViewEntries;

  /// No description provided for @contestEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Entries — {title}'**
  String contestEntriesTitle(String title);

  /// No description provided for @contestEntriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get contestEntriesEmpty;

  /// No description provided for @jobAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add job opening'**
  String get jobAddTitle;

  /// No description provided for @jobEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit job opening'**
  String get jobEditTitle;

  /// No description provided for @jobSave.
  ///
  /// In en, this message translates to:
  /// **'Save job opening'**
  String get jobSave;

  /// No description provided for @jobActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get jobActive;

  /// No description provided for @jobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitleLabel;

  /// No description provided for @jobTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Waiter / Line cook'**
  String get jobTitleHint;

  /// No description provided for @jobLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get jobLocationLabel;

  /// No description provided for @jobLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. City center'**
  String get jobLocationHint;

  /// No description provided for @jobEmploymentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Employment type'**
  String get jobEmploymentTypeLabel;

  /// No description provided for @jobEmploymentUnset.
  ///
  /// In en, this message translates to:
  /// **'— Select —'**
  String get jobEmploymentUnset;

  /// No description provided for @jobEmploymentFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get jobEmploymentFullTime;

  /// No description provided for @jobEmploymentPartTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get jobEmploymentPartTime;

  /// No description provided for @jobEmploymentContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get jobEmploymentContract;

  /// No description provided for @jobEmploymentInternship.
  ///
  /// In en, this message translates to:
  /// **'Internship'**
  String get jobEmploymentInternship;

  /// No description provided for @jobEmploymentTemporary.
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get jobEmploymentTemporary;

  /// No description provided for @jobEmploymentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get jobEmploymentOther;

  /// No description provided for @jobDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Job description'**
  String get jobDescriptionLabel;

  /// No description provided for @jobDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Role and benefits'**
  String get jobDescriptionHint;

  /// No description provided for @jobRequirementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get jobRequirementsLabel;

  /// No description provided for @jobRequirementsHint.
  ///
  /// In en, this message translates to:
  /// **'Experience, documents, skills'**
  String get jobRequirementsHint;

  /// No description provided for @jobSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary (optional)'**
  String get jobSalaryLabel;

  /// No description provided for @jobSalaryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. €400–500 / month'**
  String get jobSalaryHint;

  /// No description provided for @jobApplyEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply by email'**
  String get jobApplyEmailLabel;

  /// No description provided for @jobApplyEmailHint.
  ///
  /// In en, this message translates to:
  /// **'hr@business.com'**
  String get jobApplyEmailHint;

  /// No description provided for @jobApplyUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply URL'**
  String get jobApplyUrlLabel;

  /// No description provided for @jobApplyUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get jobApplyUrlHint;

  /// No description provided for @jobImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo / banner'**
  String get jobImageLabel;

  /// No description provided for @jobPickImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get jobPickImage;

  /// No description provided for @jobSectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Application period'**
  String get jobSectionDuration;

  /// No description provided for @jobDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: {days} days'**
  String jobDurationLabel(int days);

  /// No description provided for @jobRenewHint.
  ///
  /// In en, this message translates to:
  /// **'Saving starts a new period from today (listing has expired).'**
  String get jobRenewHint;

  /// No description provided for @jobSaved.
  ///
  /// In en, this message translates to:
  /// **'Job opening saved'**
  String get jobSaved;

  /// No description provided for @jobUpdated.
  ///
  /// In en, this message translates to:
  /// **'Job opening updated'**
  String get jobUpdated;

  /// No description provided for @jobDeleted.
  ///
  /// In en, this message translates to:
  /// **'Job opening deleted'**
  String get jobDeleted;

  /// No description provided for @jobDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete job opening?'**
  String get jobDeleteTitle;

  /// No description provided for @jobDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? All applications will be removed.'**
  String jobDeleteMessage(String title);

  /// No description provided for @jobsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No job openings yet.'**
  String get jobsEmpty;

  /// No description provided for @jobStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Accepting applications'**
  String get jobStatusLive;

  /// No description provided for @jobStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get jobStatusScheduled;

  /// No description provided for @jobStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get jobStatusExpired;

  /// No description provided for @searchJobOpenings.
  ///
  /// In en, this message translates to:
  /// **'Search job openings…'**
  String get searchJobOpenings;

  /// No description provided for @jobApplicationCount.
  ///
  /// In en, this message translates to:
  /// **'{n} applications'**
  String jobApplicationCount(int n);

  /// No description provided for @jobViewApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get jobViewApplications;

  /// No description provided for @jobApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Applications — {title}'**
  String jobApplicationsTitle(String title);

  /// No description provided for @jobApplicationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No applications yet.'**
  String get jobApplicationsEmpty;

  /// No description provided for @apiPublicShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Online shop (your store)'**
  String get apiPublicShopTitle;

  /// No description provided for @apiPublicShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each business gets a public menu at this link. Generate an API key below, then open the shop once with ?key=… so customers can place orders.'**
  String get apiPublicShopSubtitle;

  /// No description provided for @apiPublicShopCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy shop link'**
  String get apiPublicShopCopy;

  /// No description provided for @apiLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get apiLinkCopied;

  /// No description provided for @apiLivePreview.
  ///
  /// In en, this message translates to:
  /// **'Live preview'**
  String get apiLivePreview;

  /// No description provided for @apiLivePreviewTap.
  ///
  /// In en, this message translates to:
  /// **'Tap Preview on the products endpoint'**
  String get apiLivePreviewTap;

  /// No description provided for @apiLivePreviewLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading catalog preview…'**
  String get apiLivePreviewLoading;

  /// No description provided for @apiLivePreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Select a business to load preview.'**
  String get apiLivePreviewEmpty;

  /// No description provided for @apiPreviewRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh preview'**
  String get apiPreviewRefresh;

  /// No description provided for @apiIntegrationInfo.
  ///
  /// In en, this message translates to:
  /// **'Integration guide'**
  String get apiIntegrationInfo;

  /// No description provided for @apiIntegrationInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Web shop integration'**
  String get apiIntegrationInfoTitle;

  /// No description provided for @apiIntegrationGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Web integration guide'**
  String get apiIntegrationGuideTitle;

  /// No description provided for @apiIntegrationGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How to connect your menu or e-commerce site to this API.'**
  String get apiIntegrationGuideSubtitle;

  /// No description provided for @apiIntegrationReadFull.
  ///
  /// In en, this message translates to:
  /// **'Read full guide'**
  String get apiIntegrationReadFull;

  /// No description provided for @businessesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your stores'**
  String get businessesSectionTitle;

  /// No description provided for @businessesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One account · up to {maxBusinesses} stores on {planTitle}. Each store has its own catalog, orders, offers, and public API (up to {maxProducts} products per store).'**
  String businessesSectionSubtitle(
    int maxBusinesses,
    String planTitle,
    int maxProducts,
  );

  /// No description provided for @businessesQuotaUsage.
  ///
  /// In en, this message translates to:
  /// **'{owned} of {max} stores used'**
  String businessesQuotaUsage(int owned, int max);

  /// No description provided for @businessesAddStore.
  ///
  /// In en, this message translates to:
  /// **'Add store ({next}/{max})'**
  String businessesAddStore(int next, int max);

  /// No description provided for @businessesAddStoreFull.
  ///
  /// In en, this message translates to:
  /// **'Add another store ({owned}/{max})'**
  String businessesAddStoreFull(int owned, int max);

  /// No description provided for @businessesLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You reached the limit of {max} stores on your {planCode} plan. Upgrade in Settings to add more.'**
  String businessesLimitReached(int max, String planCode);

  /// No description provided for @businessesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stores yet. Create your first e-commerce store below.'**
  String get businessesEmpty;

  /// No description provided for @businessTileActive.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get businessTileActive;

  /// No description provided for @businessTileSwitch.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get businessTileSwitch;

  /// No description provided for @businessTileApiSlug.
  ///
  /// In en, this message translates to:
  /// **'Shop URL: {slug}'**
  String businessTileApiSlug(String slug);

  /// No description provided for @businessTileHint.
  ///
  /// In en, this message translates to:
  /// **'Separate products, orders & API'**
  String get businessTileHint;

  /// No description provided for @createFirstStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first store'**
  String get createFirstStoreTitle;

  /// No description provided for @createFirstStoreBody.
  ///
  /// In en, this message translates to:
  /// **'A store is a full e-commerce space: its own products, categories, offers, and public API for your website or app. You stay on one login — add more stores anytime (each extra store is billed separately).'**
  String get createFirstStoreBody;

  /// No description provided for @createFirstStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Create first store'**
  String get createFirstStoreButton;

  /// No description provided for @createStoreDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New store ({next} of {max})'**
  String createStoreDialogTitle(int next, int max);

  /// No description provided for @createStoreDialogIntro.
  ///
  /// In en, this message translates to:
  /// **'After you tap Create, payment opens ({price}, first month included). Your ATK invoice is saved on this account.'**
  String createStoreDialogIntro(String price);

  /// No description provided for @createStoreDialogAtkIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the legal entity details for your invoice (ATK): legal name, NIPT, and address.'**
  String get createStoreDialogAtkIntro;

  /// No description provided for @createStoreFiscalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice details (ATK)'**
  String get createStoreFiscalSectionTitle;

  /// No description provided for @createStoreCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createStoreCreateButton;

  /// No description provided for @businessLegalNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal entity name *'**
  String get businessLegalNameLabel;

  /// No description provided for @businessLegalNameHint.
  ///
  /// In en, this message translates to:
  /// **'As registered with tax authority'**
  String get businessLegalNameHint;

  /// No description provided for @businessLegalNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Legal name is required.'**
  String get businessLegalNameRequired;

  /// No description provided for @businessNiptLabel.
  ///
  /// In en, this message translates to:
  /// **'NIPT *'**
  String get businessNiptLabel;

  /// No description provided for @businessNiptInvalid.
  ///
  /// In en, this message translates to:
  /// **'NIPT is not valid.'**
  String get businessNiptInvalid;

  /// No description provided for @businessFiscalAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Fiscal address *'**
  String get businessFiscalAddressLabel;

  /// No description provided for @businessFiscalAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street, city'**
  String get businessFiscalAddressHint;

  /// No description provided for @businessFiscalAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Fiscal address is required.'**
  String get businessFiscalAddressRequired;

  /// No description provided for @createStoreContinuePayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get createStoreContinuePayment;

  /// No description provided for @createStoreQuotaSnack.
  ///
  /// In en, this message translates to:
  /// **'Store limit reached ({max} on your plan).'**
  String createStoreQuotaSnack(int max);

  /// No description provided for @createStoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Store created · invoice saved'**
  String get createStoreSuccess;

  /// No description provided for @switcherCreateStore.
  ///
  /// In en, this message translates to:
  /// **'Create store'**
  String get switcherCreateStore;

  /// No description provided for @switcherMenuCreateStore.
  ///
  /// In en, this message translates to:
  /// **'Add store ({owned}/{max})'**
  String switcherMenuCreateStore(int owned, int max);

  /// No description provided for @switcherTooltip.
  ///
  /// In en, this message translates to:
  /// **'Active store — switch or add another'**
  String get switcherTooltip;

  /// No description provided for @activeStoreBanner.
  ///
  /// In en, this message translates to:
  /// **'Managing: {name}'**
  String activeStoreBanner(String name);

  /// No description provided for @activeStoreBannerHint.
  ///
  /// In en, this message translates to:
  /// **'Dashboard, products and orders apply to this store only.'**
  String get activeStoreBannerHint;

  /// No description provided for @activeStoreBannerManage.
  ///
  /// In en, this message translates to:
  /// **'All stores'**
  String get activeStoreBannerManage;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @coreDetails.
  ///
  /// In en, this message translates to:
  /// **'Core Details'**
  String get coreDetails;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get productNameLabel;

  /// No description provided for @productDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescriptionLabel;

  /// No description provided for @productPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get productPriceLabel;

  /// No description provided for @productCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productCategoryLabel;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectOption;

  /// No description provided for @productActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get productActiveLabel;

  /// No description provided for @customFieldsSection.
  ///
  /// In en, this message translates to:
  /// **'Custom Fields'**
  String get customFieldsSection;

  /// No description provided for @couldNotLoadCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Could not load custom fields: {message}'**
  String couldNotLoadCustomFields(String message);

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productSaved;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted'**
  String get productDeleted;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String deleteProductMessage(String name);

  /// No description provided for @productLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Product limit reached ({usage}). Upgrade your plan in Settings.'**
  String productLimitReached(String usage);

  /// No description provided for @productImageInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid image URL. Upload the file again or use a public https URL.'**
  String get productImageInvalidUrl;

  /// No description provided for @productImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Product photos'**
  String get productImagesTitle;

  /// No description provided for @productImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} images. Only active photos appear on your online shop.'**
  String productImagesSubtitle(int max);

  /// No description provided for @productImagesMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} photos per product.'**
  String productImagesMax(int max);

  /// No description provided for @productImagesActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get productImagesActive;

  /// No description provided for @productImagesAddUrl.
  ///
  /// In en, this message translates to:
  /// **'Add URL'**
  String get productImagesAddUrl;

  /// No description provided for @variantsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get variantsSectionTitle;

  /// No description provided for @variantsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use select-type custom fields as axes (e.g. Size, Color), then generate SKU rows with price and stock.'**
  String get variantsSectionSubtitle;

  /// No description provided for @variantsSelectAxes.
  ///
  /// In en, this message translates to:
  /// **'Variant axes'**
  String get variantsSelectAxes;

  /// No description provided for @variantsGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate combinations'**
  String get variantsGenerate;

  /// No description provided for @variantsSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get variantsSku;

  /// No description provided for @variantsPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get variantsPrice;

  /// No description provided for @variantsQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get variantsQuantity;

  /// No description provided for @variantsNoAxes.
  ///
  /// In en, this message translates to:
  /// **'Add select fields with options under Custom Fields (e.g. Size, Color) to enable variants.'**
  String get variantsNoAxes;

  /// No description provided for @variantsApplyBasePrice.
  ///
  /// In en, this message translates to:
  /// **'Apply base price to all'**
  String get variantsApplyBasePrice;

  /// No description provided for @variantsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear variants'**
  String get variantsClear;

  /// No description provided for @variantsRowLabel.
  ///
  /// In en, this message translates to:
  /// **'{labels}'**
  String variantsRowLabel(String labels);

  /// No description provided for @saveField.
  ///
  /// In en, this message translates to:
  /// **'Save Field'**
  String get saveField;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get fieldLabel;

  /// No description provided for @fieldKey.
  ///
  /// In en, this message translates to:
  /// **'Key (Name)'**
  String get fieldKey;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required on products'**
  String get fieldRequired;

  /// No description provided for @fieldActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get fieldActive;

  /// No description provided for @fieldOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'Options (one per line)'**
  String get fieldOptionsHint;

  /// No description provided for @attrTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text (Short)'**
  String get attrTypeText;

  /// No description provided for @attrTypeTextarea.
  ///
  /// In en, this message translates to:
  /// **'Text (Long)'**
  String get attrTypeTextarea;

  /// No description provided for @attrTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get attrTypeNumber;

  /// No description provided for @attrTypeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get attrTypeSelect;

  /// No description provided for @attrTypeMultiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multi Select'**
  String get attrTypeMultiSelect;

  /// No description provided for @attrTypeColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get attrTypeColor;

  /// No description provided for @attrTypeBoolean.
  ///
  /// In en, this message translates to:
  /// **'Boolean'**
  String get attrTypeBoolean;

  /// No description provided for @defaultFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Default fields'**
  String get defaultFieldsTitle;

  /// No description provided for @defaultFieldsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enabled fields are required when adding a product.'**
  String get defaultFieldsSubtitle;

  /// No description provided for @businessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name *'**
  String get businessNameLabel;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business type *'**
  String get businessTypeLabel;

  /// No description provided for @businessTypeSelect.
  ///
  /// In en, this message translates to:
  /// **'Choose a type'**
  String get businessTypeSelect;

  /// No description provided for @businessTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a business type.'**
  String get businessTypeRequired;

  /// No description provided for @businessTypeRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail store'**
  String get businessTypeRetail;

  /// No description provided for @businessTypeFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion & accessories'**
  String get businessTypeFashion;

  /// No description provided for @businessTypeElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics & tech'**
  String get businessTypeElectronics;

  /// No description provided for @businessTypeIt.
  ///
  /// In en, this message translates to:
  /// **'IT & software'**
  String get businessTypeIt;

  /// No description provided for @businessTypeDigitalAgency.
  ///
  /// In en, this message translates to:
  /// **'Digital agency & marketing'**
  String get businessTypeDigitalAgency;

  /// No description provided for @businessTypeConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction & renovation'**
  String get businessTypeConstruction;

  /// No description provided for @businessTypeRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real estate'**
  String get businessTypeRealEstate;

  /// No description provided for @businessTypePhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography & video'**
  String get businessTypePhotography;

  /// No description provided for @businessTypeEvents.
  ///
  /// In en, this message translates to:
  /// **'Events & weddings'**
  String get businessTypeEvents;

  /// No description provided for @businessTypeLogistics.
  ///
  /// In en, this message translates to:
  /// **'Transport & logistics'**
  String get businessTypeLogistics;

  /// No description provided for @businessTypeAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture & farm'**
  String get businessTypeAgriculture;

  /// No description provided for @businessTypeGrocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery & supermarket'**
  String get businessTypeGrocery;

  /// No description provided for @businessTypeConvenienceStore.
  ///
  /// In en, this message translates to:
  /// **'24/7 convenience store'**
  String get businessTypeConvenienceStore;

  /// No description provided for @businessTypeBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get businessTypeBakery;

  /// No description provided for @businessTypePastry.
  ///
  /// In en, this message translates to:
  /// **'Pastry shop & cakes'**
  String get businessTypePastry;

  /// No description provided for @businessTypeWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale / B2B'**
  String get businessTypeWholesale;

  /// No description provided for @businessTypeRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get businessTypeRestaurant;

  /// No description provided for @businessTypePizzeria.
  ///
  /// In en, this message translates to:
  /// **'Pizzeria'**
  String get businessTypePizzeria;

  /// No description provided for @businessTypeCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get businessTypeCafe;

  /// No description provided for @businessTypeFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food & takeaway'**
  String get businessTypeFastFood;

  /// No description provided for @businessTypeBar.
  ///
  /// In en, this message translates to:
  /// **'Bar & lounge'**
  String get businessTypeBar;

  /// No description provided for @businessTypeCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering & banquets'**
  String get businessTypeCatering;

  /// No description provided for @businessTypeButcher.
  ///
  /// In en, this message translates to:
  /// **'Butcher shop'**
  String get businessTypeButcher;

  /// No description provided for @businessTypeIceCream.
  ///
  /// In en, this message translates to:
  /// **'Ice cream & desserts'**
  String get businessTypeIceCream;

  /// No description provided for @businessTypeFlowerShop.
  ///
  /// In en, this message translates to:
  /// **'Flower shop'**
  String get businessTypeFlowerShop;

  /// No description provided for @businessTypeJewelry.
  ///
  /// In en, this message translates to:
  /// **'Jewelry & watches'**
  String get businessTypeJewelry;

  /// No description provided for @businessTypeBookstore.
  ///
  /// In en, this message translates to:
  /// **'Bookstore & stationery'**
  String get businessTypeBookstore;

  /// No description provided for @businessTypePharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy & health'**
  String get businessTypePharmacy;

  /// No description provided for @businessTypePetShop.
  ///
  /// In en, this message translates to:
  /// **'Pet shop & grooming'**
  String get businessTypePetShop;

  /// No description provided for @businessTypeVeterinary.
  ///
  /// In en, this message translates to:
  /// **'Veterinary clinic'**
  String get businessTypeVeterinary;

  /// No description provided for @businessTypeServices.
  ///
  /// In en, this message translates to:
  /// **'General services (appointments)'**
  String get businessTypeServices;

  /// No description provided for @businessTypeSalon.
  ///
  /// In en, this message translates to:
  /// **'Hair salon & beauty'**
  String get businessTypeSalon;

  /// No description provided for @businessTypeSpa.
  ///
  /// In en, this message translates to:
  /// **'Spa & wellness'**
  String get businessTypeSpa;

  /// No description provided for @businessTypeClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic & medical practice'**
  String get businessTypeClinic;

  /// No description provided for @businessTypeDental.
  ///
  /// In en, this message translates to:
  /// **'Dental practice'**
  String get businessTypeDental;

  /// No description provided for @businessTypeAutomotive.
  ///
  /// In en, this message translates to:
  /// **'Auto service & repair'**
  String get businessTypeAutomotive;

  /// No description provided for @businessTypeFitness.
  ///
  /// In en, this message translates to:
  /// **'Gym & fitness studio'**
  String get businessTypeFitness;

  /// No description provided for @businessTypeEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & tutoring'**
  String get businessTypeEducation;

  /// No description provided for @businessTypeProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional services (legal, accounting…)'**
  String get businessTypeProfessional;

  /// No description provided for @businessTypeHomeServices.
  ///
  /// In en, this message translates to:
  /// **'Home services (repairs, cleaning…)'**
  String get businessTypeHomeServices;

  /// No description provided for @businessTypeHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel & accommodation'**
  String get businessTypeHotel;

  /// No description provided for @businessTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get businessTypeOther;

  /// No description provided for @businessSlugLabel.
  ///
  /// In en, this message translates to:
  /// **'URL Slug *'**
  String get businessSlugLabel;

  /// No description provided for @businessSlugHelper.
  ///
  /// In en, this message translates to:
  /// **'Public API path: /api/public/your-slug/products'**
  String get businessSlugHelper;

  /// No description provided for @internalSlugLabel.
  ///
  /// In en, this message translates to:
  /// **'Internal slug *'**
  String get internalSlugLabel;

  /// No description provided for @internalSlugHint.
  ///
  /// In en, this message translates to:
  /// **'electronics'**
  String get internalSlugHint;

  /// No description provided for @internalSlugHelper.
  ///
  /// In en, this message translates to:
  /// **'Not translated. Used in API, relations, and database (e.g. electronics, pizza-drinks).'**
  String get internalSlugHelper;

  /// No description provided for @internalSlugImmutableHelper.
  ///
  /// In en, this message translates to:
  /// **'Internal slug cannot be changed after creation.'**
  String get internalSlugImmutableHelper;

  /// No description provided for @internalSlugImmutableNote.
  ///
  /// In en, this message translates to:
  /// **'Slug is fixed for stable API links and relations.'**
  String get internalSlugImmutableNote;

  /// No description provided for @internalSlugTaken.
  ///
  /// In en, this message translates to:
  /// **'This internal slug is already in use.'**
  String get internalSlugTaken;

  /// No description provided for @localizedContentSection.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get localizedContentSection;

  /// No description provided for @localizedContentHelper.
  ///
  /// In en, this message translates to:
  /// **'Only the default language tab is required. Use Auto translate to fill other languages from the default.'**
  String get localizedContentHelper;

  /// No description provided for @autoTranslateButton.
  ///
  /// In en, this message translates to:
  /// **'Auto translate'**
  String get autoTranslateButton;

  /// No description provided for @autoTranslateNeedSource.
  ///
  /// In en, this message translates to:
  /// **'Fill name or description in the default language first.'**
  String get autoTranslateNeedSource;

  /// No description provided for @autoTranslateDone.
  ///
  /// In en, this message translates to:
  /// **'Translations generated. Review before saving.'**
  String get autoTranslateDone;

  /// No description provided for @seoTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'SEO title'**
  String get seoTitleLabel;

  /// No description provided for @seoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'SEO description'**
  String get seoDescriptionLabel;

  /// No description provided for @localizedSlugsSection.
  ///
  /// In en, this message translates to:
  /// **'Localized shop URL slugs'**
  String get localizedSlugsSection;

  /// No description provided for @localizedSlugsHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional per language. Default uses internal slug \"{slug}\".'**
  String localizedSlugsHelper(String slug);

  /// No description provided for @businessCreatedInvoiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Store created, but invoice could not be saved. Check Billing & invoices.'**
  String get businessCreatedInvoiceFailed;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete payment'**
  String get paymentTitle;

  /// No description provided for @paymentSubtitleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Binisoft Admin · {plan} plan'**
  String paymentSubtitleRegistration(String plan);

  /// No description provided for @paymentSubtitleNewBusiness.
  ///
  /// In en, this message translates to:
  /// **'New store · {name}'**
  String paymentSubtitleNewBusiness(String name);

  /// No description provided for @paymentPayRegistration.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} and create account'**
  String paymentPayRegistration(String amount);

  /// No description provided for @paymentPayNewBusiness.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} and create store'**
  String paymentPayNewBusiness(String amount);

  /// No description provided for @paymentDemoBannerRegistration.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: no real charge yet. Confirm below to create your account.'**
  String get paymentDemoBannerRegistration;

  /// No description provided for @paymentDemoBannerNewBusiness.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: no real charge yet. Confirm below to activate your new store.'**
  String get paymentDemoBannerNewBusiness;

  /// No description provided for @paymentActivationRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration (includes 1st month)'**
  String get paymentActivationRegistration;

  /// No description provided for @paymentActivationNewBusiness.
  ///
  /// In en, this message translates to:
  /// **'Store activation (includes 1st month)'**
  String get paymentActivationNewBusiness;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentPaypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paymentPaypal;

  /// No description provided for @paymentAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the subscription terms and recurring monthly fee after the first month.'**
  String get paymentAcceptTerms;

  /// No description provided for @paymentAcceptTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue.'**
  String get paymentAcceptTermsRequired;

  /// No description provided for @paymentInvalidCard.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card number.'**
  String get paymentInvalidCard;

  /// No description provided for @paymentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get paymentCancel;

  /// No description provided for @planChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get planChooseTitle;

  /// No description provided for @planChooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'€30 + €6/month per 100 products (1st month included in registration). Max {max} products per store.'**
  String planChooseSubtitle(int max);

  /// No description provided for @planBillingSoon.
  ///
  /// In en, this message translates to:
  /// **'Billing integration coming soon. Limits apply immediately after update.'**
  String get planBillingSoon;

  /// No description provided for @planBillingLater.
  ///
  /// In en, this message translates to:
  /// **'You can register now and use your plan limits. Billing will be enabled later.'**
  String get planBillingLater;

  /// No description provided for @planPerMonth.
  ///
  /// In en, this message translates to:
  /// **'{price}/mo after 1st month'**
  String planPerMonth(String price);

  /// No description provided for @planRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration {price} (1st month incl.)'**
  String planRegistration(String price);

  /// No description provided for @paymentThenMonthly.
  ///
  /// In en, this message translates to:
  /// **'Then monthly'**
  String get paymentThenMonthly;

  /// No description provided for @paymentTotalDueToday.
  ///
  /// In en, this message translates to:
  /// **'Total due today'**
  String get paymentTotalDueToday;

  /// No description provided for @planProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{title} · {count} products'**
  String planProductsCount(String title, int count);

  /// No description provided for @defaultFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'· required'**
  String get defaultFieldRequired;

  /// No description provided for @teamSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Team & roles'**
  String get teamSectionTitle;

  /// No description provided for @teamSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite managers (catalog + orders) or employees (orders only). Share the invite code — they register at Join team.'**
  String get teamSectionSubtitle;

  /// No description provided for @teamInviteEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get teamInviteEmail;

  /// No description provided for @teamInviteRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get teamInviteRole;

  /// No description provided for @teamInviteButton.
  ///
  /// In en, this message translates to:
  /// **'Invite team member'**
  String get teamInviteButton;

  /// No description provided for @teamEmpty.
  ///
  /// In en, this message translates to:
  /// **'No team members yet.'**
  String get teamEmpty;

  /// No description provided for @teamRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove team member?'**
  String get teamRemoveTitle;

  /// No description provided for @teamRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'They will lose access to this store.'**
  String get teamRemoveMessage;

  /// No description provided for @teamRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get teamRemoveConfirm;

  /// No description provided for @teamRemoved.
  ///
  /// In en, this message translates to:
  /// **'Team member removed'**
  String get teamRemoved;

  /// No description provided for @teamInviteAssigned.
  ///
  /// In en, this message translates to:
  /// **'Team member added — they can sign in with their existing account.'**
  String get teamInviteAssigned;

  /// No description provided for @teamInviteCreated.
  ///
  /// In en, this message translates to:
  /// **'Invite code: {code} — share it; they register at Join team.'**
  String teamInviteCreated(String code);

  /// No description provided for @teamInviteCreatedCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied: {code} — share it; they register at Join team.'**
  String teamInviteCreatedCopied(String code);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @routerPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {path}\n\nOpen: …/binisoft-ad/#/login'**
  String routerPageNotFound(String path);

  /// No description provided for @roleSuperadmin.
  ///
  /// In en, this message translates to:
  /// **'Superadmin'**
  String get roleSuperadmin;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// No description provided for @roleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get roleEmployee;

  /// No description provided for @joinTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a store team'**
  String get joinTeamTitle;

  /// No description provided for @joinTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the invite code from your store owner. No subscription payment — team access only.'**
  String get joinTeamSubtitle;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get inviteCodeLabel;

  /// No description provided for @joinTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Create account & join'**
  String get joinTeamButton;

  /// No description provided for @joinTeamSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome! You joined {store}.'**
  String joinTeamSuccess(String store);

  /// No description provided for @haveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccountLogin;

  /// No description provided for @loginJoinTeam.
  ///
  /// In en, this message translates to:
  /// **'Join with invite code'**
  String get loginJoinTeam;

  /// No description provided for @navEmployees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get navEmployees;

  /// No description provided for @pageEmployeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get pageEmployeesTitle;

  /// No description provided for @pageEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll list: name, contact, salary, pay day, and reminder before payday.'**
  String get pageEmployeesSubtitle;

  /// No description provided for @employeeAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get employeeAddTitle;

  /// No description provided for @employeeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get employeeEditTitle;

  /// No description provided for @employeeSave.
  ///
  /// In en, this message translates to:
  /// **'Save employee'**
  String get employeeSave;

  /// No description provided for @employeeFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get employeeFirstNameLabel;

  /// No description provided for @employeeLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get employeeLastNameLabel;

  /// No description provided for @employeeEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get employeeEmailLabel;

  /// No description provided for @employeeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get employeeEmailHint;

  /// No description provided for @employeePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get employeePhoneLabel;

  /// No description provided for @employeePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get employeePhoneHint;

  /// No description provided for @employeeSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary (€)'**
  String get employeeSalaryLabel;

  /// No description provided for @employeeSalaryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 450'**
  String get employeeSalaryHint;

  /// No description provided for @employeePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get employeePhotoLabel;

  /// No description provided for @employeePickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get employeePickPhoto;

  /// No description provided for @employeePaymentDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay day: day {day} of each month'**
  String employeePaymentDayLabel(int day);

  /// No description provided for @employeeReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment reminder'**
  String get employeeReminderLabel;

  /// No description provided for @employeeReminderNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get employeeReminderNone;

  /// No description provided for @employeeReminder1Day.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get employeeReminder1Day;

  /// No description provided for @employeeReminder3Days.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get employeeReminder3Days;

  /// No description provided for @employeeReminder7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days before'**
  String get employeeReminder7Days;

  /// No description provided for @employeeActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active in list'**
  String get employeeActiveLabel;

  /// No description provided for @employeeActiveHint.
  ///
  /// In en, this message translates to:
  /// **'Employee stays in the admin payroll list.'**
  String get employeeActiveHint;

  /// No description provided for @employeeShowOnSiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Show on shop page'**
  String get employeeShowOnSiteLabel;

  /// No description provided for @employeeShowOnSiteHint.
  ///
  /// In en, this message translates to:
  /// **'Visitors see them in the Team section (only when active).'**
  String get employeeShowOnSiteHint;

  /// No description provided for @employeeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter first and last name.'**
  String get employeeNameRequired;

  /// No description provided for @employeeSalaryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Salary must be a valid number.'**
  String get employeeSalaryInvalid;

  /// No description provided for @employeeCreated.
  ///
  /// In en, this message translates to:
  /// **'Employee added'**
  String get employeeCreated;

  /// No description provided for @employeeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Employee updated'**
  String get employeeUpdated;

  /// No description provided for @employeeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Employee removed'**
  String get employeeDeleted;

  /// No description provided for @employeeDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete employee?'**
  String get employeeDeleteTitle;

  /// No description provided for @employeeDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from the list?'**
  String employeeDeleteMessage(String name);

  /// No description provided for @searchEmployees.
  ///
  /// In en, this message translates to:
  /// **'Search employees…'**
  String get searchEmployees;

  /// No description provided for @employeesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No employees yet. Add the first one.'**
  String get employeesEmpty;

  /// No description provided for @employeeOnSiteBadge.
  ///
  /// In en, this message translates to:
  /// **'On site'**
  String get employeeOnSiteBadge;

  /// No description provided for @employeeReminderBadge.
  ///
  /// In en, this message translates to:
  /// **'{days}d before'**
  String employeeReminderBadge(int days);

  /// No description provided for @employeePayMeta.
  ///
  /// In en, this message translates to:
  /// **'{amount} · day {day}'**
  String employeePayMeta(String amount, int day);

  /// No description provided for @employeeNextPay.
  ///
  /// In en, this message translates to:
  /// **'Next pay: {date}'**
  String employeeNextPay(String date);

  /// No description provided for @employeeReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Payday reminder'**
  String get employeeReminderNotificationTitle;

  /// No description provided for @employeeReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{name} — pay {amount} on {date}.'**
  String employeeReminderNotificationBody(
    String name,
    String amount,
    String date,
  );

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMenu;

  /// No description provided for @storeLaunchChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish your store'**
  String get storeLaunchChecklistTitle;

  /// No description provided for @storeLaunchChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete these steps for your public site (web and mobile).'**
  String get storeLaunchChecklistSubtitle;

  /// No description provided for @storeLaunchTaskSlug.
  ///
  /// In en, this message translates to:
  /// **'Store slug / URL'**
  String get storeLaunchTaskSlug;

  /// No description provided for @storeLaunchTaskLogo.
  ///
  /// In en, this message translates to:
  /// **'Store logo'**
  String get storeLaunchTaskLogo;

  /// No description provided for @storeLaunchTaskCatalog.
  ///
  /// In en, this message translates to:
  /// **'At least 1 active product or service'**
  String get storeLaunchTaskCatalog;

  /// No description provided for @storeLaunchTaskContact.
  ///
  /// In en, this message translates to:
  /// **'Contact phone or email'**
  String get storeLaunchTaskContact;

  /// No description provided for @storeLaunchTaskPreview.
  ///
  /// In en, this message translates to:
  /// **'Open your public store page'**
  String get storeLaunchTaskPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'sq':
      return AppLocalizationsSq();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
