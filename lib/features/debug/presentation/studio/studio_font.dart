/// Latin faces bundled for the mock. Bangla always falls back to Noto Sans Bengali.
enum StudioFont {
  manrope('Manrope'),
  jakarta('PlusJakartaSans');

  const StudioFont(this.family);

  final String family;
}
