import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/style/app_spacing.dart';

class ContentCard extends StatefulWidget {
  final ContentItem content;
  final double width;
  final VoidCallback? onTap;
  final bool isSelected;

  const ContentCard({
    super.key,
    required this.content,
    required this.width,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
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
    bool isRecent = false;
    String? releaseDateStr;
    DateTime? releaseDate;

    if (widget.content.contentType == ContentType.series) {
      releaseDateStr = widget.content.seriesStream?.releaseDate;
    }

    if (releaseDateStr != null && releaseDateStr.isNotEmpty) {
      try {
        releaseDate = DateTime.parse(releaseDateStr);
      } catch (e) {
        releaseDate = null;
      }
    }

    if (releaseDate != null) {
      final diff = DateTime.now().difference(releaseDate).inDays;
      isRecent = diff <= 15;
    }

    final bool isLiveStream = widget.content.contentType == ContentType.liveStream;
    final Widget? ratingBadge = isLiveStream ? null : _buildRatingBadge(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        elevation: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          side: widget.isSelected
              ? BorderSide(color: AppColors.primary, width: 2)
              : BorderSide.none,
        ),
        color: widget.isSelected
            ? AppPalette.primaryLightOf(context)
            : Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: widget.onTap,
          onHover: _onHoverChanged,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: widget.content.imagePath.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.content.imagePath,
                              fit: _getFitForContentType(),
                              placeholder: (context, url) => Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildTitleCard(context),
                            )
                          : _buildTitleCard(context),
                    ),
                    if (ratingBadge != null) ratingBadge,
                    if (isRecent)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.successGreen,
                                AppColors.successIRNew,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.successGreen.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            context.loc.new_ep,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                        child: Text(
                          widget.content.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxFit _getFitForContentType() {
    if (widget.content.contentType == ContentType.liveStream) {
      return BoxFit.contain;
    }
    return BoxFit.cover;
  }

  Widget _buildTitleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isSelected
              ? [
                  AppPalette.primaryLightOf(context).withValues(alpha: 0.5),
                  AppPalette.primaryLightOf(context).withValues(alpha: 0.3),
                ]
              : [
                  AppPalette.neutral500Of(context),
                  AppPalette.neutral600Of(context),
                ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            widget.content.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: widget.isSelected
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget? _buildRatingBadge(BuildContext context) {
    final dynamic rawRating = widget.content.contentType == ContentType.series
        ? widget.content.seriesStream?.rating
        : widget.content.vodStream?.rating;

    final double? rating = _parseRating(rawRating);
    if (rating == null || rating <= 0) {
      return null;
    }

    final formattedRating = rating % 1 == 0
        ? rating.toStringAsFixed(0)
        : rating.toStringAsFixed(1);

    return Positioned(
      top: 6,
      right: 6,
      child: Semantics(
        label: 'Rating $formattedRating',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.infoYellow.withValues(alpha: 0.95),
                AppColors.infoYellow.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.infoYellow.withValues(alpha: 0.4),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.brown,
              ),
              const SizedBox(width: 3),
              Text(
                formattedRating,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                  color: AppColors.brown,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _parseRating(dynamic rating) {
    if (rating == null) return null;
    if (rating is num) return rating.toDouble();
    if (rating is String && rating.isNotEmpty) {
      final normalized = rating.replaceAll(',', '.');
      return double.tryParse(normalized);
    }
    return null;
  }
}
