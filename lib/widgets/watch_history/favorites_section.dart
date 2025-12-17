import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/models/favorite.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/widgets/content_card.dart';
import 'package:another_iptv_player/utils/navigate_by_content_type.dart';
import 'package:another_iptv_player/utils/get_playlist_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/models/live_stream.dart';
import 'package:another_iptv_player/models/vod_streams.dart';
import 'package:another_iptv_player/models/series.dart';
import 'package:another_iptv_player/models/m3u_item.dart';
import '../../repositories/favorites_repository.dart';

class FavoritesSection extends StatelessWidget {
  final List<Favorite> favorites;
  final double cardWidth;
  final double cardHeight;
  final VoidCallback? onSeeAllTap;
  final Function(Favorite)? onFavoriteRemove;

  const FavoritesSection({
    super.key,
    required this.favorites,
    required this.cardWidth,
    required this.cardHeight,
    this.onSeeAllTap,
    this.onFavoriteRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return SizedBox.shrink();
    }

    final recentFavorites = favorites.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.favorites,
                style: AppTypography.headline4,
              ),
              if (onSeeAllTap != null && favorites.length > 10)
                TextButton(
                  onPressed: onSeeAllTap,
                  child: Text(context.loc.see_all_favorites, style: AppTypography.buttonSmall),
                ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight + 16,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: recentFavorites.length,
            itemBuilder: (context, index) {
              final favorite = recentFavorites[index];
              return _buildFavoriteCard(context, favorite);
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Favorite favorite) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          FutureBuilder<ContentItem?>(
            future: _getContentItemFromFavorite(favorite),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final contentItem =
                  snapshot.data ?? _convertFavoriteToContentItem(favorite);

              return ContentCard(
                content: contentItem,
                width: cardWidth,
                onTap: () => _navigateToContent(context, contentItem),
              );
            },
          ),
          if (onFavoriteRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: _AnimatedDeleteButton(
                onTap: () async {
                  onFavoriteRemove?.call(favorite);
                },
              ),
            ),
        ],
      ),
    );
  }

  ContentItem _convertFavoriteToContentItem(Favorite favorite) {
    if (isXtreamCode) {
      switch (favorite.contentType) {
        case ContentType.liveStream:
          final liveStream = LiveStream(
            streamId: favorite.streamId,
            name: favorite.name,
            streamIcon: favorite.imagePath ?? '',
            categoryId: '',
            epgChannelId: '',
          );
          return ContentItem(
            favorite.streamId,
            favorite.name,
            favorite.imagePath ?? '',
            favorite.contentType,
            liveStream: liveStream,
          );

        case ContentType.vod:
          final vodStream = VodStream(
            streamId: favorite.streamId,
            name: favorite.name,
            streamIcon: favorite.imagePath ?? '',
            categoryId: '',
            rating: '',
            rating5based: 0.0,
            containerExtension: '',
            createdAt: DateTime.now(),
          );
          return ContentItem(
            favorite.streamId,
            favorite.name,
            favorite.imagePath ?? '',
            favorite.contentType,
            vodStream: vodStream,
          );

        case ContentType.series:
          final seriesStream = SeriesStream(
            seriesId: favorite.streamId,
            name: favorite.name,
            cover: favorite.imagePath ?? '',
            categoryId: '',
            playlistId: favorite.playlistId,
          );
          return ContentItem(
            favorite.streamId,
            favorite.name,
            favorite.imagePath ?? '',
            favorite.contentType,
            seriesStream: seriesStream,
          );
      }
    }
    else if (isM3u) {
      final m3uItem = M3uItem(
        id: favorite.m3uItemId ?? favorite.streamId,
        playlistId: favorite.playlistId,
        url: favorite.streamId,
        contentType: favorite.contentType,
        name: favorite.name,
        tvgLogo: favorite.imagePath,
      );
      return ContentItem(
        favorite.streamId,
        favorite.name,
        favorite.imagePath ?? '',
        favorite.contentType,
        m3uItem: m3uItem,
      );
    }

    return ContentItem(
      favorite.streamId,
      favorite.name,
      favorite.imagePath ?? '',
      favorite.contentType,
    );
  }

  Future<ContentItem?> _getContentItemFromFavorite(Favorite favorite) async {
    final repository = FavoritesRepository();
    return await repository.getContentItemFromFavorite(favorite);
  }

  void _navigateToContent(BuildContext context, ContentItem contentItem) {
    navigateByContentType(context, contentItem);
  }
}

class _AnimatedDeleteButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedDeleteButton({required this.onTap});

  @override
  State<_AnimatedDeleteButton> createState() => _AnimatedDeleteButtonState();
}

class _AnimatedDeleteButtonState extends State<_AnimatedDeleteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
