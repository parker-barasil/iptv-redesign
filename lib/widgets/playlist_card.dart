import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../models/playlist_model.dart';
import '../../utils/playlist_utils.dart';
import '../core/style/app_colors.dart';
import '../core/style/app_spacing.dart';

class PlaylistCard extends StatefulWidget {
  final Playlist playlist;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: AppSpacing.curveFast),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        shadowColor: PlaylistUtils.getPlaylistColor(
          widget.playlist.type,
        ).withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        child: InkWell(
          onTap: widget.onTap,
          onHover: _onHoverChanged,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Container(
            padding: AppSpacing.paddingLg,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusLg,
              gradient: _isHovered
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        AppPalette.primaryLightOf(
                          context,
                        ).withValues(alpha: 0.1),
                      ],
                    )
                  : null,
            ),
            child: Row(
              children: [
                _PlaylistIcon(type: widget.playlist.type),
                SizedBox(width: AppSpacing.lg),
                Expanded(child: _PlaylistInfo(playlist: widget.playlist)),
                _PlaylistMenu(onDelete: widget.onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistIcon extends StatelessWidget {
  final PlaylistType type;

  const _PlaylistIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.accentGradientList,
          // colors: [
          //   PlaylistUtils.getPlaylistColor(type),
          //   PlaylistUtils.getPlaylistColor(type).withValues(alpha: 0.7),
          // ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: PlaylistUtils.getPlaylistColor(type).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        PlaylistUtils.getPlaylistIcon(type),
        color: AppColors.white,
        size: 28,
      ),
    );
  }
}

class _PlaylistInfo extends StatelessWidget {
  final Playlist playlist;

  const _PlaylistInfo({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.name,
          style: AppTypography.headline4,
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            _TypeChip(type: playlist.type),
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.access_time_rounded,
              size: 14,
              color: AppPalette.neutral700Of(context),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              PlaylistUtils.formatDate(playlist.createdAt),
              style: AppTypography.body3Regular.copyWith(
                color: AppPalette.neutral700Of(context),
              ),
            ),
          ],
        ),
        if (playlist.url != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            playlist.url!,
            style: AppTypography.body3Regular.copyWith(
              color: AppPalette.neutral700Of(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final PlaylistType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = PlaylistUtils.getPlaylistColor(type);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        type.toString().split('.').last.toUpperCase(),
        style: AppTypography.body3SemiBold.copyWith(
          fontSize: 11,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PlaylistMenu extends StatelessWidget {
  final VoidCallback onDelete;

  const _PlaylistMenu({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: AppPalette.neutral700Of(context),
      ),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      elevation: AppSpacing.elevationMd,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, color: AppColors.errorPink, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text(
                context.loc.delete,
                style: AppTypography.body2Regular.copyWith(color: AppColors.errorPink),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'delete') {
          onDelete();
        }
      },
    );
  }
}
