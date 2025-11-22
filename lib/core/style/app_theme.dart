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
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      tooltipTheme: _tooltipTheme,
      popupMenuTheme: _popupMenuTheme,
      drawerTheme: _drawerTheme,
      navigationRailTheme: _navigationRailTheme,
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
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      tooltipTheme: _tooltipTheme,
      popupMenuTheme: _popupMenuTheme,
      drawerTheme: _drawerTheme,
      navigationRailTheme: _navigationRailTheme,
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

  // App Bar Theme
  static AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: Colors.transparent, // surface from colorScheme
    foregroundColor: Colors.transparent, // onSurface from colorScheme
    elevation: AppSpacing.elevationXs,
    scrolledUnderElevation: AppSpacing.elevationSm,
    centerTitle: true,
    titleTextStyle: AppTypography.headline3.copyWith(
      color: Colors.transparent, // onSurface from colorScheme
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
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

  // Input Decoration Theme
  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutralDark700,
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

  // Card Theme
  static CardThemeData get _cardTheme => CardThemeData(
    color: Colors.transparent, // surface from colorScheme
    elevation: AppSpacing.elevationSm,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    margin: AppSpacing.paddingSm,
  );

  // Bottom Navigation Bar Theme
  static const BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent, // surface from colorScheme
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.transparent, // onSurfaceVariant from colorScheme
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

  // Bottom Sheet Theme
  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
    backgroundColor: Colors.transparent, // surface from colorScheme
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  // Tab Bar Theme
  static const TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: Colors.transparent, // onSurfaceVariant from colorScheme
    indicatorColor: AppColors.primary,
    labelStyle: AppTypography.buttonSmall,
    unselectedLabelStyle: AppTypography.buttonSmall,
  );

  // Tooltip Theme
  static const TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.neutralDark800,
      borderRadius: AppSpacing.borderRadiusSm,
    ),
    textStyle: AppTypography.buttonSmall,
  );

  // Popup Menu Theme
  static PopupMenuThemeData get _popupMenuTheme => PopupMenuThemeData(
    color: Colors.transparent, // surface from colorScheme
    elevation: AppSpacing.elevationMd,
    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
  );

  // Drawer Theme
  static DrawerThemeData get _drawerTheme => DrawerThemeData(
    backgroundColor: Colors.transparent, // surface from colorScheme
    elevation: AppSpacing.elevationLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(AppSpacing.radiusLg),
        bottomRight: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );

  // Navigation Rail Theme
  static NavigationRailThemeData get _navigationRailTheme =>
      NavigationRailThemeData(
    backgroundColor: Colors.transparent, // surface from colorScheme
    selectedIconTheme: IconThemeData(color: AppColors.primary),
    unselectedIconTheme: IconThemeData(color: Colors.transparent), // onSurfaceVariant from colorScheme
    selectedLabelTextStyle: AppTypography.buttonSmall,
    unselectedLabelTextStyle: AppTypography.buttonSmall,
  );
}
