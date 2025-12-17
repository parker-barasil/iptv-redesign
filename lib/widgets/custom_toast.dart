import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import '../core/style/app_colors.dart';

enum ToastType {
  success,
  error,
  info,
  warning,
}

class CustomToast {
  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Удаляем предыдущий toast если он есть
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);
    final animationController = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 350),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutBack,
    ));

    final opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: opacityAnimation,
              child: child,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: _ToastWidget(
              message: message,
              type: type,
              onDismiss: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  animationController.dispose();
                  if (_currentToast == overlayEntry) {
                    _currentToast = null;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );

    _currentToast = overlayEntry;
    overlay.insert(overlayEntry);

    // Анимация появления
    animationController.forward();

    // Автоматическое скрытие
    Future.delayed(duration, () {
      if (_currentToast == overlayEntry) {
        animationController.reverse().then((_) {
          overlayEntry.remove();
          animationController.dispose();
          _currentToast = null;
        });
      }
    });
  }

  static void dismiss() {
    _currentToast?.remove();
    _currentToast = null;
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  Color _getAccentColor(BuildContext context) {
    switch (type) {
      case ToastType.success:
        return AppColors.successGreen;
      case ToastType.error:
        return AppColors.errorPink;
      case ToastType.warning:
        return AppColors.warningOrange;
      case ToastType.info:
        return AppColors.infoBlue;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      switch (type) {
        case ToastType.success:
          return AppColors.successDarkGreen;
        case ToastType.error:
          return AppColors.errorDarkPink;
        case ToastType.warning:
          return AppColors.warningDarkOrange;
        case ToastType.info:
          return AppColors.infoDarkYellow;
      }
    }
    return AppColors.white;
  }

  Color _getBorderColor(BuildContext context) {
    final accentColor = _getAccentColor(context);
    return accentColor.withValues(alpha: 0.3);
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  Color _getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.white : AppColors.neutral900;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(context);
    final backgroundColor = _getBackgroundColor(context);
    final borderColor = _getBorderColor(context);
    final textColor = _getTextColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.3 : 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body2Medium.copyWith(
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: textColor.withValues(alpha: 0.6),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
