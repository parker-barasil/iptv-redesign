import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/watch_history.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/style/app_spacing.dart';

class WatchHistoryCard extends StatefulWidget {
  final WatchHistory history;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showProgress;

  const WatchHistoryCard({
    super.key,
    required this.history,
    required this.width,
    required this.height,
    this.onTap,
    this.onRemove,
    this.showProgress = false,
  });

  @override
  State<WatchHistoryCard> createState() => _WatchHistoryCardState();
}

class _WatchHistoryCardState extends State<WatchHistoryCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
          shadowColor: _getContentTypeColor(widget.history.contentType).withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onHover: _onHoverChanged,
            child: Stack(
              children: [
                // Background/Thumbnail
                _buildThumbnail(),

                // Remove Button
                if (widget.onRemove != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: widget.onRemove,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.errorPink.withValues(alpha: 0.9),
                              AppColors.errorPink.withValues(alpha: 0.8),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorPink.withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.close_rounded, color: AppColors.white, size: 16),
                      ),
                    ),
                  ),

                // Progress Bar (if applicable)
                if (widget.showProgress &&
                    widget.history.watchDuration != null &&
                    widget.history.totalDuration != null)
                  Positioned(
                    bottom: 30,
                    left: 8,
                    right: 8,
                    child: _buildProgressBar(),
                  ),

                // Content Info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.history.title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (widget.history.imagePath != null && widget.history.imagePath!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.history.imagePath!,
        width: double.infinity,
        height: double.infinity,
        fit: _getFitForContentType(),
        placeholder: (context, url) => Container(
          color: AppPalette.neutral500Of(context),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultThumbnail(),
      );
    } else {
      return _buildDefaultThumbnail();
    }
  }

  BoxFit _getFitForContentType() {
    if (widget.history.contentType == ContentType.liveStream) {
      return BoxFit.contain;
    }
    return BoxFit.cover;
  }

  Widget _buildDefaultThumbnail() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getContentTypeColor(widget.history.contentType).withValues(alpha: 0.8),
            _getContentTypeColor(widget.history.contentType),
          ],
        ),
      ),
      child: Icon(
        _getContentTypeIcon(widget.history.contentType),
        size: 48,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.history.totalDuration!.inMilliseconds.isInfinite
        ? 0.0
        : (widget.history.watchDuration!.inMilliseconds /
              widget.history.totalDuration!.inMilliseconds);

    return Column(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppColors.white.withValues(alpha: 0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.isInfinite || progress.isNaN ? 0 : progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(widget.history.watchDuration!),
              style: TextStyle(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            Text(
              _formatDuration(widget.history.totalDuration!),
              style: TextStyle(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getContentTypeColor(ContentType type) {
    switch (type) {
      case ContentType.liveStream:
        return AppColors.errorPink;
      case ContentType.vod:
        return AppColors.primary;
      case ContentType.series:
        return AppColors.successGreen;
    }
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.liveStream:
        return Icons.live_tv_rounded;
      case ContentType.vod:
        return Icons.movie_rounded;
      case ContentType.series:
        return Icons.tv_rounded;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
