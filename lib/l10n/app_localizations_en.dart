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
  String get navReports => 'Reports';

  @override
  String get navBusinesses => 'Businesses';

  @override
  String get navProducts => 'Products';

  @override
  String get navOffers => 'Offers';

  @override
  String get navCategories => 'Categories';

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
  String get menuCreateBusiness => 'Create new business';

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
      'All businesses on your account — switch active or create new.';

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
  String get pageCategoriesTitle => 'Categories';

  @override
  String get pageCategoriesSubtitle => 'Manage your product categories.';

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
  String get settingsBusinessName => 'Business Name';

  @override
  String get settingsDescription => 'Description';

  @override
  String get settingsDescriptionHint => 'A brief description of your business';

  @override
  String get settingsLogoUrl => 'Logo URL';

  @override
  String get settingsOrderPhone => 'Order phone (WhatsApp)';

  @override
  String get subscriptionPlanTitle => 'Subscription plan';

  @override
  String get changePlan => 'Change plan';

  @override
  String get settingsOrderPhoneNote =>
      'Used when your online shop sends orders via WhatsApp.';

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
}
