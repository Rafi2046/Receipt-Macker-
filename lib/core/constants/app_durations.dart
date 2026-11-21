/// Animation and UI timing.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  /// One cycle of a slow, looping decorative animation.
  static const Duration ambientLoop = Duration(milliseconds: 2800);
  static const Duration snackbar = Duration(seconds: 4);
}
