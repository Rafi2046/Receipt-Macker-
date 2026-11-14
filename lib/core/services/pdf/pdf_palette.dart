/// Colors used inside PDF templates (CSS hex). Brand: bottle green and
/// gold, as in `AppColors.light()`. Paper is always white, whatever the
/// app theme.
abstract final class PdfPalette {
  static const String brand = 'var(--brand-accent, #FF5738)';
  static const String brandSoft = 'var(--brand-accent-soft, #FFF1EE)';
  static const String accent = '#2563EB';
  static const String ink = '#111827';
  static const String muted = '#6B7280';
  static const String line = '#E5E7EB';
  static const String zebra = '#F8F9FA';
  static const String paper = '#FFFFFF';
}
