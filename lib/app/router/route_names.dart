/// Route names and paths. Navigate by name, never by raw strings in widgets.
abstract final class RouteNames {
  static const String home = 'home';
  static const String homePath = '/';
  static const String more = 'more';
  static const String morePath = '/more';
  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';
  static const String businessProfile = 'businessProfile';
  static const String businessProfilePath = '/business-profile';
  static const String settings = 'settings';
  static const String settingsPath = '/settings';
  static const String backup = 'backup';
  static const String backupPath = '/backup';
  static const String paywall = 'paywall';
  static const String paywallPath = '/paywall';
  static const String proWelcome = 'proWelcome';
  static const String proWelcomePath = '/pro-welcome';
  static const String support = 'support';
  static const String supportPath = '/support';
  static const String privacy = 'privacy';
  static const String privacyPath = '/privacy';
  static const String terms = 'terms';
  static const String termsPath = '/terms';

  /// Path parameter holding a record id, e.g. `/clients/:id`.
  static const String idParam = 'id';
  static const String _newPath = 'new';
  static const String _editPath = ':$idParam';

  static const String clients = 'clients';
  static const String clientsPath = '/clients';
  static const String clientNew = 'clientNew';
  static const String clientNewPath = _newPath;
  static const String clientDetail = 'clientDetail';
  static const String clientDetailPath = ':$idParam';
  static const String clientEdit = 'clientEdit';
  static const String clientEditPath = 'edit';

  static const String items = 'items';
  static const String itemsPath = '/items';
  static const String itemNew = 'itemNew';
  static const String itemNewPath = _newPath;
  static const String itemEdit = 'itemEdit';
  static const String itemEditPath = _editPath;

  static const String invoices = 'invoices';
  static const String invoicesPath = '/invoices';
  static const String invoiceNew = 'invoiceNew';
  static const String invoiceNewPath = _newPath;
  static const String invoiceDetail = 'invoiceDetail';
  static const String invoiceDetailPath = ':$idParam';
  static const String invoiceEdit = 'invoiceEdit';
  static const String invoiceEditPath = 'edit';
  static const String invoicePdf = 'invoicePdf';
  static const String invoicePdfPath = 'pdf';
  static const String paymentIdParam = 'paymentId';
  static const String paymentReceipt = 'paymentReceipt';
  static const String paymentReceiptPath = 'payments/:$paymentIdParam';

  /// Query parameter of [invoiceNew]: the invoice to copy.
  static const String copyOfParam = 'copyOf';

  static const String quotes = 'quotes';
  static const String quotesPath = '/quotes';
  static const String quoteNew = 'quoteNew';
  static const String quoteNewPath = _newPath;
  static const String quoteEdit = 'quoteEdit';
  static const String quoteEditPath = _editPath;
  static const String quotePdf = 'quotePdf';
  static const String quotePdfPath = 'pdf';

  // Debug builds only.
  static const String themePreview = 'themePreview';
  static const String themePreviewPath = '/debug/theme';
  static const String widgetGallery = 'widgetGallery';
  static const String widgetGalleryPath = '/debug/widgets';
  static const String designDirections = 'designDirections';
  static const String designDirectionsPath = '/debug/directions';
}
