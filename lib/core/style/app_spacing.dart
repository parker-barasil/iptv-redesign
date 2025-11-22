import 'package:flutter/material.dart';

/// App spacing and sizing constants for consistent layout
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // Base spacing unit (4dp)
  static const double _baseUnit = 4.0;

  // Spacing values
  static const double xs = _baseUnit; // 4dp
  static const double sm = _baseUnit * 2; // 8dp
  static const double md = _baseUnit * 3; // 12dp
  static const double lg = _baseUnit * 4; // 16dp
  static const double xl = _baseUnit * 6; // 24dp
  static const double xxl = _baseUnit * 8; // 32dp
  static const double xxxl = _baseUnit * 12; // 48dp
  static const double xxxxl = _baseUnit * 16; // 64dp

  // Padding and margin values
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHXxl = EdgeInsets.symmetric(horizontal: xxl);

  // Vertical padding
  static const EdgeInsets paddingVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVXxl = EdgeInsets.symmetric(vertical: xxl);

  // Border radius values
  static const double radiusXs = _baseUnit; // 4dp
  static const double radiusSm = _baseUnit * 1.5; // 6dp
  static const double radiusMd = _baseUnit * 2; // 8dp
  static const double radiusLg = _baseUnit * 3; // 12dp
  static const double radiusXl = _baseUnit * 4; // 16dp
  static const double radiusXll = _baseUnit * 5; // 20dp
  static const double radiusXxl = _baseUnit * 6; // 24dp
  static const double radiusCircular = 50.0; // For circular elements

  // Border radius objects
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusXxl = BorderRadius.all(
    Radius.circular(radiusXxl),
  );

  // Component sizes
  static const double buttonHeightSmall = 40.0; // small
  static const double buttonHeightMedium = 48.0; // medium
  static const double buttonHeightLarge = 56.0; // large
  static const double buttonHeightExtraLarge = 80.0; // large

  static const double iconButtonSizeSmall = 16.0;
  static const double iconButtonSizeMedium = 20.0;
  static const double iconButtonSizeLarge = 24.0;
  static const double iconButtonSizeExtraLarge = 24.0;

  static const double inputHeight = 48.0;
  static const double inputHeightSmall = 40.0;
  static const double inputHeightLarge = 56.0;

  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXl = 48.0;

  static const double avatarSize = 40.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeLarge = 56.0;
  static const double avatarSizeXl = 80.0;

  // App bar and navigation
  static const double appBarHeight = 56.0;
  static const double bottomNavigationHeight = 80.0;
  static const double tabBarHeight = 48.0;

  // Dividers and separators
  static const double dividerThickness = 1.0;
  static const double dividerThicknessThick = 2.0;

  // Shadows
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Animation curves
  static const Curve curveFast = Curves.easeInOut;
  static const Curve curveNormal = Curves.easeInOut;
  static const Curve curveSlow = Curves.easeInOut;

  // Helper methods for creating custom spacing
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left ?? horizontal ?? all ?? 0,
      top: top ?? vertical ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
    );
  }

  static BorderRadius borderRadius({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    double? all,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? all ?? 0),
      topRight: Radius.circular(topRight ?? all ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? all ?? 0),
      bottomRight: Radius.circular(bottomRight ?? all ?? 0),
    );
  }
}
