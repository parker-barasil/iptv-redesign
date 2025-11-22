import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';

class PlaylistLoadingState extends StatelessWidget {
  const PlaylistLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(context.loc.loading_playlists),
        ],
      ),
    );
  }
}

class PlaylistErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const PlaylistErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColors.errorPink),
            const SizedBox(height: 16),
            Text(
              context.loc.error_occurred,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: AppColors.errorPink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: context.loc.try_again,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
              style: AppButtonStyleEnum.primaryGradient,
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistEmptyState extends StatelessWidget {
  final VoidCallback onCreatePlaylist;

  const PlaylistEmptyState({super.key, required this.onCreatePlaylist});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add_rounded, size: 80, color: AppColors.neutral600),
            const SizedBox(height: 24),
            Text(
              context.loc.empty_playlist_title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.loc.empty_playlist_message,
              // 'İlk playlist\'inizi oluşturarak başlayın.\nXtream Code veya M3U formatında\nplaylist ekleyebilirsiniz.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.neutral700,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: context.loc.empty_playlist_button,
              icon: Icons.add_rounded,
              onPressed: onCreatePlaylist,
              style: AppButtonStyleEnum.primaryGradient,
              size: AppButtonSizeEnum.large,
            ),
          ],
        ),
      ),
    );
  }
}
