/// Buyer details for ATK-compliant invoices when activating a store.
class BusinessFiscalDetails {
  const BusinessFiscalDetails({
    required this.legalName,
    required this.nipt,
    required this.fiscalAddress,
  });

  final String legalName;
  final String nipt;
  final String fiscalAddress;

  static String? validateNipt(String raw) {
    final v = raw.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
    if (v.length < 8) return 'NIPT is too short';
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(v)) {
      return 'NIPT may only contain letters and digits';
    }
    return null;
  }
}
