import 'package:flutter/material.dart';

/// App color palette containing all colors used throughout the application
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C4BFB); // primary900
  static const Color primaryLight = Color(0xFFE0E7FF); // primary800
  static const Color primaryLightest = Color(0xFFF8F5FC); // primary700
  static const Color primaryDark = Color(0xFF1D2438); // primaryDark800
  static const Color primaryContainer = Color(0xFF2F2838); // primaryDark700

  // Neutral Colors
  static const Color neutral900 = Color(0xFF050103); // gray900
  static const Color neutral800 = Color(0xFF6B7280); // gray800
  static const Color neutral700 = Color(0xFF9CA3AF); // gray700
  static const Color neutral600 = Color(0xFFE2E3E8); // gray600
  static const Color neutral500 = Color(0xFFF1F2F4); // gray500
  static const Color neutralDark900 = Color(0xFF050103); // grayDark400
  static const Color neutralDark800 = Color(0xFF9CA3AF); // grayDark800
  static const Color neutralDark700 = Color(0xFF6B7280); // grayDark700
  static const Color neutralDark600 = Color(0xFF454545); // grayDark600
  static const Color neutralDark500 = Color(0xFF2F2F2F); // grayDark500

  // General and Specific Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color brown = Color(0xFF78350F); // for text on yellow background

  // Gradients
  static const accentGradientList = [Color(0xFF733EF0), Color(0xFFF5336F)];
  static const LinearGradient accentGradient = LinearGradient(
    colors: accentGradientList,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9133EA), Color(0xFF5145E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Alert Colors (Semantic)
  static const Color errorPink = Color(0xFFFF3366); // alertPink
  static const Color errorLightPink = Color(0xFFF5C3CF); // alertLightPink
  static const Color errorDarkPink = Color(0xFF461A25); // alertDarkPink
  static const Color warningOrange = Color(0xFFFF5757); // alertOrange
  static const Color warningLightOrange = Color(0xFFFBC9C9); // alertLightOrange
  static const Color warningDarkOrange = Color(0xFF381212); // alertDarkOrange
  static const Color successGreen = Color(0xFF1DAF41); // alertGreen
  static const Color successIRNew = Color(0xFF4AAC7A); // IR New/green
  static const Color successLightGreen = Color(0xFFD7F3DE); // alertLightGreen
  static const Color successDarkGreen = Color(0xFF0D3521); // alertDarkGreen
  static const Color infoYellow = Color(0xFFFDD700); // alertYellow
  static const Color infoLightYellow = Color(0xFFF6EEC1); // alertLightYellow
  static const Color infoDarkYellow = Color(0xFF37331C); // alertDarkYellow
  static const Color infoBlue = Color(0xFF3B82F6); // Blue info color for success banners
}

/// Adaptive palette helpers that return light/dark counterparts
/// for commonly paired colors, based on current theme brightness.
class AppPalette {
  AppPalette._();

  static bool _isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  // Neutral scale (maps to neutralDark* in dark theme)
  static Color neutral500Of(BuildContext context) =>
      _isDark(context) ? AppColors.neutralDark500 : AppColors.neutral500;
  static Color neutral600Of(BuildContext context) =>
      _isDark(context) ? AppColors.neutralDark600 : AppColors.neutral600;
  static Color neutral700Of(BuildContext context) =>
      _isDark(context) ? AppColors.neutralDark700 : AppColors.neutral700;
  static Color neutral800Of(BuildContext context) =>
      _isDark(context) ? AppColors.neutralDark800 : AppColors.neutral800;
  static Color neutral900Of(BuildContext context) =>
      _isDark(context) ? AppColors.neutralDark900 : AppColors.neutral900;

  // Primary light variant (maps to primaryDark in dark theme)
  static Color primaryLightOf(BuildContext context) =>
      _isDark(context) ? AppColors.primaryDark : AppColors.primaryLight;
  static Color primaryLightestOf(BuildContext context) =>
      _isDark(context) ? AppColors.primaryDark : AppColors.primaryLightest;

  // Primary stays the same across themes (kept for API symmetry)
  static Color primaryOf(BuildContext context) => AppColors.primary;
}
