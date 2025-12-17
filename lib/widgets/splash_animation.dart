import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/style/app_colors.dart';

class SplashAnimation extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final Duration duration;

  const SplashAnimation({
    super.key,
    this.onAnimationComplete,
    this.duration = const Duration(milliseconds: 2400),
  });

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Callback after animation completes
    Future.delayed(widget.duration, () {
      if (mounted) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.neutralDark900,
          ],
        ),
      ),
      child: Center(
        child: Lottie.asset(
          'assets/splash.lottie',
          controller: _controller,
          repeat: true,
          animate: true,
          fit: BoxFit.contain,
          width: 300,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            // Fallback in case Lottie file has issues
            return Icon(
              Icons.play_circle_filled,
              size: 120,
              color: AppColors.primary,
            );
          },
          onLoaded: (composition) {
            // Start the animation when loaded
            _controller.duration = composition.duration;
            _controller.repeat();
          },
        ),
      ),
    );
  }
}
