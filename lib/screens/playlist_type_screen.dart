import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/screens/m3u/new_m3u_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/style/app_spacing.dart';
import 'xtream-codes/new_xtream_code_playlist_screen.dart';

class PlaylistTypeScreen extends StatelessWidget {
  const PlaylistTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.create_new_playlist,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        context.loc.select_playlist_type,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        context.loc.select_playlist_message,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppPalette.neutral700Of(context),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),
                      _buildPlaylistTypeCard(
                        context,
                        title: 'Xtream Codes',
                        subtitle: context.loc.xtream_code_title,
                        description: context.loc.xtream_code_description,
                        icon: Icons.stream_rounded,
                        gradientColors: [AppColors.primary, AppColors.infoBlue],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewXtreamCodePlaylistScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _buildPlaylistTypeCard(
                        context,
                        title: 'M3U Playlist',
                        subtitle: context.loc.m3u_playlist_title,
                        description: context.loc.m3u_playlist_description,
                        icon: Icons.playlist_play_rounded,
                        gradientColors: [AppColors.successGreen, AppColors.successIRNew],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewM3uPlaylistScreen(),
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppPalette.primaryLightOf(context).withValues(alpha: 0.15),
                              AppPalette.primaryLightOf(context).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: AppSpacing.borderRadiusLg,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.primary),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                context.loc.select_playlist_type_footer,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: AppSpacing.elevationMd,
      shadowColor: gradientColors[0].withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusXl,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 30, color: AppColors.white),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: gradientColors[0],
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: AppPalette.neutral700Of(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppPalette.neutral600Of(context),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
