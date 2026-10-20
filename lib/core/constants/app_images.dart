/// Asset paths for images. Files are added as the features need them.
abstract final class AppImages {
  static const String _base = 'assets/images';
  static const String logo = '$_base/logo.png';
  static const String emptyInvoices = '$_base/empty_invoices.png';

  // Logo concepts for the owner's pick (debug preview only). Removed once
  // the final icon is generated from the chosen SVG in assets/branding/.
  static const String _concepts = 'assets/branding/preview';
  static const List<String> logoConcepts = [
    '$_concepts/concept_a_receipt_bolt.png',
    '$_concepts/concept_b_q_document.png',
    '$_concepts/concept_c_fast_sheet.png',
  ];
}
