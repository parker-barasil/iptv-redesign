import 'package:flutter/material.dart';
import '../constants/enums/app_button_variants_enum.dart';
import '../style/index.dart';

/// AppButton - unified button component with 4 sizes and 4 background styles
///
/// Sizes: small (40px), medium (48px), large (56px), extraLarge (56px)
/// Styles: primaryGradient, accentGradient, primaryLight, text (no background)
/// States: active, inactive
///
/// Optional subtitle support for inactive states (e.g., "Trial ended")
class AppButton extends StatelessWidget {
  final String text;
  final String? subtitle;
  final VoidCallback? onPressed;
  final AppButtonStyleEnum style;
  final AppButtonSizeEnum size;
  final bool isActive;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.subtitle,
    this.onPressed,
    this.style = AppButtonStyleEnum.primaryGradient,
    this.size = AppButtonSizeEnum.medium,
    this.isActive = true,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    // For gradient buttons, use Container with gradient
    if (style == AppButtonStyleEnum.primaryGradient ||
        style == AppButtonStyleEnum.accentGradient) {
      return _buildGradientButton(context);
    }

    // For other styles, use standard button widgets
    return _buildStandardButton(context);
  }

  Widget _buildGradientButton(BuildContext context) {
    final gradient = style == AppButtonStyleEnum.primaryGradient
        ? AppColors.primaryGradient
        : AppColors.accentGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: isActive ? gradient : null,
        color: isActive ? null : AppPalette.neutral500Of(context),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          child: Center(
            child: _buildButtonContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardButton(BuildContext context) {
    // Use OutlinedButton for outline style
    if (style == AppButtonStyleEnum.outline) {
      return OutlinedButton(
        onPressed: isActive && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: _getTextColor(context),
          disabledForegroundColor: _getTextColor(context),
          side: BorderSide(
            color: isActive ? AppColors.primary : AppPalette.neutral500Of(context),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: _buildButtonContent(context),
        ),
      );
    }

    return ElevatedButton(
      onPressed: isActive && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(context),
        foregroundColor: _getTextColor(context),
        disabledBackgroundColor: _getBackgroundColor(context),
        disabledForegroundColor: _getTextColor(context),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Center(
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context)),
        ),
      );
    }

    // Build content with subtitle support
    // Layout: Row with [Icon + Text], then Subtitle below in a separate row
    if (subtitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First row: Icon + Title
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon!,
                  size: _getIconSize(),
                  color: _getTextColor(context),
                ),
                SizedBox(width: AppSpacing.sm),
              ],
              Text(
                text,
                style: _getTextStyle().copyWith(
                  color: _getTextColor(context),
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Second row: Subtitle
          Text(
            subtitle!,
            style: AppTypography.body2Regular.copyWith(
              color: _getTextColor(context),
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      );
    }

    // Standard layout without subtitle
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon!,
            size: _getIconSize(),
            color: _getTextColor(context),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: _getTextStyle().copyWith(
              color: _getTextColor(context),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle().copyWith(
        color: _getTextColor(context),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    // Active state
    if (isActive) {
      switch (style) {
        case AppButtonStyleEnum.primaryLight:
          return AppPalette.primaryLightOf(context);
        case AppButtonStyleEnum.text:
          return Colors.transparent;
        case AppButtonStyleEnum.danger:
          return AppColors.errorPink;
        case AppButtonStyleEnum.outline:
          return Colors.transparent;
        case AppButtonStyleEnum.primaryGradient:
        case AppButtonStyleEnum.accentGradient:
          return Colors.transparent; // Handled by gradient
      }
    }

    // Inactive state - all buttons use neutral colors
    if (style == AppButtonStyleEnum.text) {
      return Colors.transparent; // Text button - transparent background in any state
    }
    return AppPalette.neutral500Of(context); // All others - neutral500
  }

  Color _getTextColor(BuildContext context) {
    // Active state
    if (isActive) {
      switch (style) {
        case AppButtonStyleEnum.primaryGradient:
        case AppButtonStyleEnum.accentGradient:
        case AppButtonStyleEnum.danger:
          return AppColors.white;
        case AppButtonStyleEnum.primaryLight:
          return AppColors.primary;
        case AppButtonStyleEnum.text:
          return AppColors.primary;
        case AppButtonStyleEnum.outline:
          return AppColors.primary;
      }
    }

    // Inactive state
    if (style == AppButtonStyleEnum.text) {
      return AppPalette.neutral600Of(context); // Text button - neutral600
    }
    return AppPalette.neutral700Of(context); // All others - neutral700
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSizeEnum.small:
        return AppTypography.buttonSmall;
      case AppButtonSizeEnum.medium:
        return AppTypography.buttonMedium;
      case AppButtonSizeEnum.large:
      case AppButtonSizeEnum.extraLarge:
        return AppTypography.buttonLarge;
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSizeEnum.small:
        return AppSpacing.buttonHeightSmall;
      case AppButtonSizeEnum.medium:
        return AppSpacing.buttonHeightMedium;
      case AppButtonSizeEnum.large:
        return AppSpacing.buttonHeightLarge;
      case AppButtonSizeEnum.extraLarge:
        return AppSpacing.buttonHeightExtraLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSizeEnum.small:
        return AppSpacing.iconButtonSizeSmall;
      case AppButtonSizeEnum.medium:
        return AppSpacing.iconButtonSizeMedium;
      case AppButtonSizeEnum.large:
        return AppSpacing.iconButtonSizeLarge;
      case AppButtonSizeEnum.extraLarge:
        return AppSpacing.iconButtonSizeExtraLarge;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppButtonSizeEnum.small:
        return 11.0;
      case AppButtonSizeEnum.medium:
        return 14.0;
      case AppButtonSizeEnum.large:
        return 16.0;
      case AppButtonSizeEnum.extraLarge:
        return 16.0;
    }
  }
}
