import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/models/watch_history.dart';
import 'package:another_iptv_player/screen.dart';
import 'package:another_iptv_player/widgets/watch_history/watch_history_app_bar_widget.dart';
import 'package:another_iptv_player/widgets/content_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/watch_history_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../models/favorite.dart';
import '../../models/playlist_content_model.dart';

class WatchHistoryContent extends StatelessWidget {
  final Function(dynamic) onHistoryTap;
  final Function(dynamic) onHistoryRemove;
  final Function(String, List<WatchHistory>) onSeeAllTap;
  final Function(Favorite)? onFavoriteRemove;
  final VoidCallback? onSeeAllFavorites;

  const WatchHistoryContent({
    super.key,
    required this.onHistoryTap,
    required this.onHistoryRemove,
    required this.onSeeAllTap,
    this.onFavoriteRemove,
    this.onSeeAllFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchHistoryController>(
      builder: (context, controller, child) {
        final allHistories = controller.allHistory;
        final subtleColor = Theme.of(context).colorScheme.onSurfaceVariant;

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              WatchHistoryAppBar(
                onRefresh: controller.loadWatchHistory,
                onClearAll: controller.clearAllHistory,
                onRefreshFavorites: () {
                  final favoritesController = context.read<FavoritesController>();
                  favoritesController.loadFavorites();
                },
              ),
            ];
          },
          body: allHistories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BrowseContentScreen()),
                        ),
                        child: Icon(Icons.history, size: 64, color: subtleColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.loc.history,
                        style: AppTypography.headline3.copyWith(color: subtleColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.loc.history_empty_message,
                        style: AppTypography.body2Regular.copyWith(color: subtleColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: allHistories.map((history) {
                      return GestureDetector(
                        onLongPress: () => onHistoryRemove(history),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ContentCard(
                                content: ContentItem(
                                  history.streamId,
                                  history.title,
                                  history.imagePath ?? '',
                                  history.contentType,
                                ),
                                width: constraints.maxWidth,
                                onTap: () => onHistoryTap(history),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        );
      },
    );
  }
}
