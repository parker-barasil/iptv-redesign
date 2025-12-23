import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
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

  const PlaylistErrorState({super.key, required this.error, required this.onRetry});

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
            Text(context.loc.error_occurred, style: AppTypography.headline3.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTypography.body2Regular.copyWith(color: AppColors.errorPink),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Icon(Icons.playlist_add_rounded, size: 60, color: AppPalette.neutral600Of(context)),
            const SizedBox(height: 24),
            Text(
              context.loc.empty_playlist_title,
              style: AppTypography.headline2.copyWith(color: AppPalette.neutral700Of(context)),
            ),
            const SizedBox(height: 12),
            // Text(
            //   context.loc.empty_playlist_message,
            //   style: AppTypography.body1Regular.copyWith(
            //     color: AppPalette.neutral700Of(context),
            //     height: 1.4,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 12),
            InstructionsWidget(),

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

class InstructionsWidget extends StatelessWidget {
  const InstructionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrimary = AppPalette.neutral700Of(context);
    final colorText = AppPalette.neutral700Of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          context.loc.instructions_title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        _InstructionItem(
          index: 1,
          title: context.loc.instruction_step_1_title,
          subtitle: context.loc.instruction_step_1_subtitle,
          colorPrimary: colorPrimary,
        ),

        _InstructionItem(
          index: 2,
          title: context.loc.instruction_step_2_title,
          subtitle: context.loc.instruction_step_2_subtitle,
          colorPrimary: colorPrimary,
        ),

        _InstructionItem(
          index: 3,
          title: context.loc.instruction_step_3_title,
          subtitle: context.loc.instruction_step_3_subtitle,
          colorPrimary: colorPrimary,
        ),

        _InstructionItem(
          index: 4,
          title: context.loc.instruction_step_4_title,
          subtitle: context.loc.instruction_step_4_subtitle,
          colorPrimary: colorPrimary,
        ),

        SizedBox(height: 80),
      ],
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final Color colorPrimary;

  const _InstructionItem({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.colorPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final colorText = AppPalette.neutral700Of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NUMBER
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorPrimary, width: 1.5),
            ),
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16, color: colorPrimary, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Icon(Icons.info_outline, color: colorPrimary, size: 16),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: TextStyle(color: colorText.withOpacity(0.85), height: 1.35, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
