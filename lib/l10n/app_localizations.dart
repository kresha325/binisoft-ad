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

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

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

  /// No description provided for @settingsLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingsLocation;

  /// No description provided for @settingsLocationHint.
  ///
  /// In en, this message translates to:
  /// **'City, address, or area'**
  String get settingsLocationHint;

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
  /// **'Colors, sections, gallery and social links for your public storefront.'**
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
  /// **'Up to 5 items — image and/or YouTube embed per slot.'**
  String get siteGalleryHint;

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

  /// No description provided for @settingsOrderPhone.
  ///
  /// In en, this message translates to:
  /// **'Order phone (WhatsApp)'**
  String get settingsOrderPhone;

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
  /// **'Used when your online shop sends orders via WhatsApp.'**
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
  /// **'Each new store needs a one-time activation ({price}, first month included). You will get an invoice on this account.'**
  String createStoreDialogIntro(String price);

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
