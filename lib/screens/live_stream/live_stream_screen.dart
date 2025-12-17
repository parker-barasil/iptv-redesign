import 'dart:async';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/utils/get_playlist_type.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import '../../../models/content_type.dart';
import '../../../services/event_bus.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/content_card.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/player_widget.dart';
import '../../../controllers/favorites_controller.dart';
import '../../../models/favorite.dart';
import '../../utils/toast_utils.dart';

class LiveStreamScreen extends StatefulWidget {
  final ContentItem content;

  const LiveStreamScreen({super.key, required this.content});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late ContentItem contentItem;
  List<ContentItem> allContents = [];
  bool allContentsLoaded = false;
  int selectedContentItemIndex = 0;
  late StreamSubscription contentItemIndexChangedSubscription;
  late FavoritesController _favoritesController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    contentItem = widget.content;
    _favoritesController = FavoritesController();
    _initializeQueue();
    _checkFavoriteStatus();
  }

  Future<void> _initializeQueue() async {
    allContents = isXtreamCode
        ? (await AppState.xtreamCodeRepository!.getLiveChannelsByCategoryId(
            categoryId: widget.content.liveStream!.categoryId,
          ))!.map((x) {
            return ContentItem(
              x.streamId,
              x.name,
              x.streamIcon,
              ContentType.liveStream,
              liveStream: x,
            );
          }).toList()
        : (await AppState.m3uRepository!.getM3uItemsByCategoryId(
            categoryId: widget.content.m3uItem!.categoryId!,
          ))!.map((x) {
            return ContentItem(
              x.url,
              x.name ?? 'NO NAME',
              x.tvgLogo ?? '',
              ContentType.liveStream,
              m3uItem: x,
            );
          }).toList();

    setState(() {
      selectedContentItemIndex = allContents.indexWhere(
        (element) => element.id == widget.content.id,
      );
      allContentsLoaded = true;
    });

    contentItemIndexChangedSubscription = EventBus()
        .on<int>('player_content_item_index')
        .listen((int index) {
          if (!mounted) return;

          setState(() {
            selectedContentItemIndex = index;
            contentItem = allContents[selectedContentItemIndex];
          });
          _checkFavoriteStatus();
        });
  }

  @override
  void dispose() {
    contentItemIndexChangedSubscription.cancel();
    _favoritesController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _favoritesController.isFavorite(
      contentItem.id,
      contentItem.contentType,
    );
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final result = await _favoritesController.toggleFavorite(contentItem);
    if (mounted) {
      setState(() {
        _isFavorite = result;
      });

      ToastUtils.showSuccess(
        context,
        result
            ? context.loc.added_to_favorites
            : context.loc.removed_from_favorites,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!allContentsLoaded) {
      return Scaffold(body: SafeArea(child: buildFullScreenLoadingWidget(context)));
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: isLandscape ? null : AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(context.loc.live),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.errorPink : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: isLandscape ? 1 : 0,
              child: PlayerWidget(
                contentItem: widget.content,
                queue: allContents,
              ),
            ),
            if (!isLandscape)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      SelectableText(
                        contentItem.name,
                        style: AppTypography.headline2.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      SelectableText(
                        context.loc.other_channels,
                        style: AppTypography.headline4.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...allContents.asMap().entries.map((entry) {
                        final index = entry.key;
                        final content = entry.value;
                        final isSelected = selectedContentItemIndex == index;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                height: 140,
                                child: ContentCard(
                                  content: content,
                                  width: constraints.maxWidth,
                                  isSelected: isSelected,
                                  onTap: () => _onContentTap(content),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),

                      // SelectableText(
                      //   context.loc.channel_information,
                      //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 16),

                      // _buildInfoCard(
                      //   icon: Icons.tv_rounded,
                      //   title: context.loc.channel_id,
                      //   value: contentItem.id.toString(),
                      //   color: AppColors.infoBlue,
                      // ),
                      // const SizedBox(height: 12),

                      // _buildInfoCard(
                      //   icon: Icons.category_rounded,
                      //   title: context.loc.category_id,
                      //   value:
                      //       contentItem.liveStream?.categoryId ??
                      //       context.loc.not_found_in_category,
                      //   color: AppColors.successGreen,
                      // ),
                      // const SizedBox(height: 12),

                      // _buildInfoCard(
                      //   icon: Icons.high_quality_rounded,
                      //   title: context.loc.quality,
                      //   value: _getQualityText(),
                      //   color: AppColors.warningOrange,
                      // ),
                      // const SizedBox(height: 12),

                      // _buildInfoCard(
                      //   icon: Icons.signal_cellular_alt_rounded,
                      //   title: context.loc.stream_type,
                      //   value:
                      //       contentItem.containerExtension?.toUpperCase() ??
                      //       context.loc.live,
                      //   color: AppColors.primary,
                      // ),
                      // const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral500.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutral600.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  title,
                  style: AppTypography.body3Medium.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getQualityText() {
    return 'HD';
  }

  _onContentTap(ContentItem contentItem) {
    setState(() {
      if (!mounted) return;

      selectedContentItemIndex = allContents.indexOf(contentItem);
    });
    EventBus().emit(
      'player_content_item_index_changed',
      selectedContentItemIndex,
    );
  }
}
