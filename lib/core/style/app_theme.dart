import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Main app theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      primaryTextTheme: _textTheme,
      appBarTheme: _lightAppBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      cardTheme: _lightCardTheme,
      bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomSheetTheme: _lightBottomSheetTheme,
      tabBarTheme: _lightTabBarTheme,
      tooltipTheme: _lightTooltipTheme,
      popupMenuTheme: _lightPopupMenuTheme,
      drawerTheme: _lightDrawerTheme,
      navigationRailTheme: _lightNavigationRailTheme,
    );
  }

  /// Dark theme
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _textTheme,
      primaryTextTheme: _textTheme,
      appBarTheme: _darkAppBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      cardTheme: _darkCardTheme,
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomSheetTheme: _darkBottomSheetTheme,
      tabBarTheme: _darkTabBarTheme,
      tooltipTheme: _darkTooltipTheme,
      popupMenuTheme: _darkPopupMenuTheme,
      drawerTheme: _darkDrawerTheme,
      navigationRailTheme: _darkNavigationRailTheme,
    );
  }

  // Color Schemes
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.neutral900,
    secondary: AppColors.primaryLight,
    onSecondary: AppColors.neutral900,
    secondaryContainer: AppColors.primaryLight,
    onSecondaryContainer: AppColors.neutral800,
    tertiary: AppColors.infoYellow,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.infoLightYellow,
    onTertiaryContainer: AppColors.neutral800,
    error: AppColors.errorPink,
    onError: AppColors.white,
    errorContainer: AppColors.errorLightPink,
    onErrorContainer: AppColors.neutral900,
    surface: AppColors.white,
    onSurface: AppColors.neutral900,
    onSurfaceVariant: AppColors.neutral700,
    surfaceContainerHighest: AppColors.neutralDark700,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.white,
    secondary: AppColors.primaryDark,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.primaryContainer,
    onSecondaryContainer: AppColors.neutralDark800,
    tertiary: AppColors.infoYellow,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.infoDarkYellow,
    onTertiaryContainer: AppColors.neutralDark800,
    error: AppColors.errorPink,
    onError: AppColors.white,
    errorContainer: AppColors.errorDarkPink,
    onErrorContainer: AppColors.white,
    surface: AppColors.neutralDark900,
    onSurface: AppColors.white,
    onSurfaceVariant: AppColors.neutralDark700,
    surfaceContainerHigh: AppColors.neutralDark700,
    surfaceContainerHighest: AppColors.neutralDark600,
    surfaceContainer: AppColors.neutralDark500,
  );

  // Text Theme
  static const TextTheme _textTheme = TextTheme(
    headlineLarge: AppTypography.headline1,
    headlineMedium: AppTypography.headline2,
    headlineSmall: AppTypography.headline3,
    titleLarge: AppTypography.headline4,
    titleMedium: AppTypography.headline5,
    bodyLarge: AppTypography.body1Regular,
    bodyMedium: AppTypography.body2Regular,
    bodySmall: AppTypography.body3Regular,
    labelLarge: AppTypography.buttonLarge,
    labelMedium: AppTypography.buttonMedium,
    labelSmall: AppTypography.buttonSmall,
  );

  // App Bar Themes
  static AppBarTheme get _lightAppBarTheme => AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.neutral900,
    elevation: AppSpacing.elevationXs,
    scrolledUnderElevation: AppSpacing.elevationSm,
    centerTitle: true,
    titleTextStyle: AppTypography.headline3.copyWith(
      color: AppColors.neutral900,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static AppBarTheme get _darkAppBarTheme => AppBarTheme(
    backgroundColor: AppColors.neutralDark900,
    foregroundColor: AppColors.white,
    elevation: AppSpacing.elevationXs,
    scrolledUnderElevation: AppSpacing.elevationSm,
    centerTitle: true,
    titleTextStyle: AppTypography.headline3.copyWith(
      color: AppColors.white,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Button Themes
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGradient.colors[0],
      foregroundColor: AppColors.white,
      elevation: AppSpacing.elevationSm,
      minimumSize: Size(0, AppSpacing.buttonHeightMedium),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary),
      minimumSize: Size(0, AppSpacing.buttonHeightMedium),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: Size(0, AppSpacing.buttonHeightMedium),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  // Input Decoration Themes
  static const InputDecorationTheme _lightInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutral500,
    border: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.neutral600),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.neutral600),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.errorPink),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.errorPink, width: 2),
    ),
    contentPadding: AppSpacing.paddingHMd,
    labelStyle: AppTypography.textOutsideTitle,
    hintStyle: AppTypography.textPlaceholder,
    errorStyle: AppTypography.textValidation,
  );

  static const InputDecorationTheme _darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutralDark600,
    border: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.neutralDark700),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.neutralDark700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.errorPink),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      borderSide: BorderSide(color: AppColors.errorPink, width: 2),
    ),
    contentPadding: AppSpacing.paddingHMd,
    labelStyle: AppTypography.textOutsideTitle,
    hintStyle: AppTypography.textPlaceholder,
    errorStyle: AppTypography.textValidation,
  );

  // Card Themes
  static CardThemeData get _lightCardTheme => CardThemeData(
    color: AppColors.white,
    elevation: AppSpacing.elevationSm,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    margin: AppSpacing.paddingSm,
  );

  static CardThemeData get _darkCardTheme => CardThemeData(
    color: AppColors.neutralDark600,
    elevation: AppSpacing.elevationSm,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    margin: AppSpacing.paddingSm,
  );

  // Bottom Navigation Bar Themes
  static const BottomNavigationBarThemeData _lightBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.neutral700,
    type: BottomNavigationBarType.fixed,
    elevation: AppSpacing.elevationMd,
  );

  static const BottomNavigationBarThemeData _darkBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.neutralDark900,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.neutralDark800,
    type: BottomNavigationBarType.fixed,
    elevation: AppSpacing.elevationMd,
  );

  // Floating Action Button Theme
  static final FloatingActionButtonThemeData _floatingActionButtonTheme =
      FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryGradient.colors[0],
    foregroundColor: AppColors.white,
    elevation: AppSpacing.elevationMd,
  );

  // Bottom Sheet Themes
  static BottomSheetThemeData get _lightBottomSheetTheme => BottomSheetThemeData(
    backgroundColor: AppColors.white,
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  static BottomSheetThemeData get _darkBottomSheetTheme => BottomSheetThemeData(
    backgroundColor: AppColors.neutralDark600,
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  // Tab Bar Themes
  static const TabBarThemeData _lightTabBarTheme = TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.neutral700,
    indicatorColor: AppColors.primary,
    labelStyle: AppTypography.buttonSmall,
    unselectedLabelStyle: AppTypography.buttonSmall,
  );

  static const TabBarThemeData _darkTabBarTheme = TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.neutralDark800,
    indicatorColor: AppColors.primary,
    labelStyle: AppTypography.buttonSmall,
    unselectedLabelStyle: AppTypography.buttonSmall,
  );

  // Tooltip Themes
  static const TooltipThemeData _lightTooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.neutral800,
      borderRadius: AppSpacing.borderRadiusSm,
    ),
    textStyle: AppTypography.buttonSmall,
  );

  static const TooltipThemeData _darkTooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.neutralDark700,
      borderRadius: AppSpacing.borderRadiusSm,
    ),
    textStyle: AppTypography.buttonSmall,
  );

  // Popup Menu Themes
  static PopupMenuThemeData get _lightPopupMenuTheme => PopupMenuThemeData(
    color: AppColors.white,
    elevation: AppSpacing.elevationMd,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
  );

  static PopupMenuThemeData get _darkPopupMenuTheme => PopupMenuThemeData(
    color: AppColors.neutralDark600,
    elevation: AppSpacing.elevationMd,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
  );

  // Drawer Themes
  static DrawerThemeData get _lightDrawerTheme => DrawerThemeData(
    backgroundColor: AppColors.white,
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(AppSpacing.radiusLg),
        bottomRight: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  static DrawerThemeData get _darkDrawerTheme => DrawerThemeData(
    backgroundColor: AppColors.neutralDark900,
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(AppSpacing.radiusLg),
        bottomRight: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  // Navigation Rail Themes
  static NavigationRailThemeData get _lightNavigationRailTheme =>
      NavigationRailThemeData(
    backgroundColor: AppColors.white,
    selectedIconTheme: IconThemeData(color: AppColors.primary),
    unselectedIconTheme: IconThemeData(color: AppColors.neutral700),
    selectedLabelTextStyle: AppTypography.buttonSmall,
    unselectedLabelTextStyle: AppTypography.buttonSmall,
  );

  static NavigationRailThemeData get _darkNavigationRailTheme =>
      NavigationRailThemeData(
    backgroundColor: AppColors.neutralDark900,
    selectedIconTheme: IconThemeData(color: AppColors.primary),
    unselectedIconTheme: IconThemeData(color: AppColors.neutralDark800),
    selectedLabelTextStyle: AppTypography.buttonSmall,
    unselectedLabelTextStyle: AppTypography.buttonSmall,
  );
}
