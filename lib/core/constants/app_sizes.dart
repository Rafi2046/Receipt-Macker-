/// Fixed component sizes: icons, buttons, tap targets, layout widths.
abstract final class AppSizes {
  static const double iconSm = 16, iconMd = 24, iconLg = 32, iconXl = 48;
  static const double buttonHeight = 48;
  static const double minTapTarget = 48;
  static const double avatarSm = 32, avatarMd = 40, avatarLg = 56;
  static const double progressSm = 20;
  static const double progressStroke = 2.5;
  static const double emptyStateMaxWidth = 360;
  static const double imagePreviewHeight = 96;
  static const double signaturePadHeight = 220;
  static const double signatureStroke = 2.5;
  static const double languageCardHeight = 72;
  static const double swatch = 56;
  static const double swatchWidth = 96;
  static const double borderWidth = 1;
  static const double selectedBorderWidth = 2;
  static const double maxContentWidth = 640;

  /// Space under the last list row so the floating button never covers it.
  static const double fabClearance = 88;

  /// Widest an extended floating button's label may get, as a share of
  /// the screen width.
  static const double fabLabelMaxWidthFactor = 0.6;

  /// Launcher icon size on a typical phone home screen.
  static const double launcherIcon = 56;

  /// Android 12+ splash: the icon is shown in a circle this wide.
  static const double splashIcon = 160;
}
