import 'package:flutter/material.dart';

/// App typography containing all text styles used throughout the application
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // Font families
  static const String _fontFamily = 'OpenSans';

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Headline styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: bold,
    height: 1.2,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.2,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.2,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: bold,
    height: 1.2,
  );

  // Body styles
  static const TextStyle body1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.4,
  );

  static const TextStyle body1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.4,
  );

  static const TextStyle body1SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.4,
  );

  static const TextStyle body2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.4,
  );

  static const TextStyle body2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
  );

  static const TextStyle body2SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.4,
  );

  static const TextStyle body3Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.3,
  );

  static const TextStyle body3Medium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.3,
  );

  static const TextStyle body3SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: semiBold,
    height: 1.3,
  );

  // Buttons & Links
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: medium,
    height: 1.33, // 24 / 18
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5, // 24 / 16
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.43, // 20 / 14
  );

  static const TextStyle buttonExtraSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: semiBold,
    height: 1.17, // 14 / 12
  );

  // Fields (Inputs / Placeholders / Validation)
  static const TextStyle textOutsideTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.43, // 20 / 14
  );

  static const TextStyle textPlaceholder = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5, // 24 / 16
  );

  static const TextStyle textValidation = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.43, // 20 / 14
  );

  // Helpers
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
