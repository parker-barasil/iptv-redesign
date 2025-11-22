import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: AppColors.errorPink),
          const SizedBox(height: 16),
          Text('Hata: $message', style: TextStyle(color: AppColors.errorPink)),
          const SizedBox(height: 16),
          AppButton(
            text: 'Tekrar Dene',
            icon: Icons.refresh_rounded,
            onPressed: onRetry,
            style: AppButtonStyleEnum.primaryGradient,
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_rounded, size: 64, color: AppColors.neutral600),
          SizedBox(height: 16),
          Text(
            context.loc.not_found_in_category,
            style: TextStyle(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }
}
