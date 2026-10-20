/// Due-date presets. [custom] means a date that matches no preset.
enum DueTerm {
  onReceipt(0),
  days7(7),
  days15(15),
  days30(30),
  custom(null);

  const DueTerm(this.days);

  /// Days after the issue date; null for [custom].
  final int? days;

  /// The preset that matches [days], or [custom].
  static DueTerm fromDays(int days) =>
      values.firstWhere((t) => t.days == days, orElse: () => DueTerm.custom);
}
