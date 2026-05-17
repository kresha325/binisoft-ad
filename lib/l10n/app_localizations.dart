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
  /// **'Create new business'**
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
  /// **'All businesses on your account — switch active or create new.'**
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
