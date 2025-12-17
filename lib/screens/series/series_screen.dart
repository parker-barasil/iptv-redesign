import 'package:flutter/material.dart';
import 'package:another_iptv_player/database/database.dart';
import 'package:another_iptv_player/models/api_configuration_model.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/favorites_controller.dart';
import '../../utils/toast_utils.dart';
import 'episode_screen.dart';

class SeriesScreen extends StatefulWidget {
  final ContentItem contentItem;

  const SeriesScreen({super.key, required this.contentItem});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late IptvRepository _repository;
  late FavoritesController _favoritesController;
  SeriesInfosData? seriesInfo;
  List<SeasonsData> seasons = [];
  List<EpisodesData> episodes = [];
  bool isLoading = true;
  String? error;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _favoritesController = FavoritesController();
    _loadSeriesDetails();
    _checkFavoriteStatus();
  }

  void _initializeRepository() {
    _repository = IptvRepository(
      ApiConfig(
        baseUrl: AppState.currentPlaylist!.url!,
        username: AppState.currentPlaylist!.username!,
        password: AppState.currentPlaylist!.password!,
      ),
      AppState.currentPlaylist!.id,
    );
  }

  Future<void> _loadSeriesDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final seriesId = widget.contentItem.id;

      final seriesResponse = await _repository.getSeriesInfo(seriesId);

      if (seriesResponse != null) {
        setState(() {
          seriesInfo = seriesResponse.seriesInfo;
          seasons = seriesResponse.seasons;
          episodes = seriesResponse.episodes;
          isLoading = false;
        });
      } else {
        setState(() {
          error = context.loc.preparing_series_exception_1;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = context.loc.preparing_series_exception_2(e.toString());
        isLoading = false;
      });
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _favoritesController.isFavorite(
      widget.contentItem.id,
      widget.contentItem.contentType,
    );

    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final result = await _favoritesController.toggleFavorite(widget.contentItem);
    if (mounted) {
      setState(() {
        _isFavorite = result;
      });

      ToastUtils.showSuccess(
        context,
        result ? context.loc.added_to_favorites : context.loc.removed_from_favorites,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: false,
              snap: false,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Hero(
                      tag: widget.contentItem.id,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: _buildCoverImage(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7, 1.0],
                          colors: [
                            AppColors.neutralDark900.withValues(alpha: 0.1),
                            AppColors.neutralDark900.withValues(alpha: 0.3),
                            AppColors.neutralDark900.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    seriesInfo?.name ?? widget.contentItem.name,
                                    style: AppTypography.headline2.copyWith(
                                      color: AppColors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                          color: AppColors.neutralDark900.withValues(alpha: 0.54),
                                        ),
                                      ],
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                // Favori butonu
                                IconButton(
                                  onPressed: _toggleFavorite,
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: _isFavorite ? AppColors.errorPink : AppColors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            if (seriesInfo?.genre != null ||
                                widget.contentItem.seriesStream?.genre !=
                                    null) ...[
                              const SizedBox(height: 8),
                              Text(
                                seriesInfo?.genre ??
                                    widget.contentItem.seriesStream?.genre ??
                                    '',
                                style: AppTypography.body2Regular.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: AppColors.neutralDark900.withValues(alpha: 0.54),
                                    ),
                                  ],
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppPalette.neutral900Of(context).withValues(alpha: 0.8),
                AppPalette.neutral900Of(context),
              ],
            ),
          ),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(context.loc.preparing_series, style: AppTypography.body1Regular),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColors.errorPink),
            const SizedBox(height: 16),
            Text(
              error!,
              style: AppTypography.body1Regular.copyWith(color: AppColors.errorPink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: context.loc.try_again,
              icon: Icons.refresh_rounded,
              onPressed: _loadSeriesDetails,
              style: AppButtonStyleEnum.primaryGradient,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Bölümü
          _buildRatingSection(),
          const SizedBox(height: 20),

          // Sezonlar Bölümü
          _buildSeasonsSection(),
          const SizedBox(height: 24),

          // Dizi Bilgileri
          _buildSeriesDetails(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    final rating = seriesInfo?.rating5based ?? 0;
    final ratingText =
        widget.contentItem.seriesStream?.rating5based?.toStringAsFixed(1) ??
            '0.0';

    return Row(
      children: [
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              index < rating.round()
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: AppColors.infoYellow,
              size: 24,
            ),
          );
        }),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.infoYellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$ratingText/5',
            style: AppTypography.body2SemiBold.copyWith(
              color: AppColors.infoYellow,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.season,
          style: AppTypography.headline4,
        ),
        const SizedBox(height: 12),
        if (seasons.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.neutral500.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral600.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.neutral600),
                const SizedBox(width: 12),
                Text(context.loc.not_found_in_category, style: AppTypography.body2Regular),
              ],
            ),
          )
        else
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final season = seasons[index];
                return _buildSeasonCard(season, index);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSeasonCard(SeasonsData season, int index) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral500.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral600.withValues(alpha: 0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showSeasonEpisodes(season);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.play_circle_outline_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        season.name,
                        style: AppTypography.body1SemiBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.loc.episode_count(
                    (season.episodeCount ?? 0).toString(),
                  ),
                  style: AppTypography.body2Regular.copyWith(color: AppColors.neutral600),
                ),
                if (season.airDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    season.airDate!,
                    style: AppTypography.body3Regular.copyWith(color: AppColors.neutral700),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeriesDetails() {
    final details = <Map<String, dynamic>>[];

    // Açıklama
    final plot = seriesInfo?.plot ?? widget.contentItem.seriesStream?.plot;
    if (plot != null && plot.isNotEmpty) {
      details.add({
        'icon': Icons.description,
        'title': context.loc.description,
        'value': plot,
      });
    }

    // Çıkış Tarihi
    final releaseDate =
        seriesInfo?.releaseDate ?? widget.contentItem.seriesStream?.releaseDate;
    details.add({
      'icon': Icons.calendar_today,
      'title': context.loc.release_date,
      'value': releaseDate ?? context.loc.not_found_in_category,
    });

    // Tür
    final genre = seriesInfo?.genre ?? widget.contentItem.seriesStream?.genre;
    if (genre != null && genre.isNotEmpty) {
      details.add({
        'icon': Icons.movie,
        'title': context.loc.genre,
        'value': genre,
      });
    }

    // Oyuncular
    final cast = seriesInfo?.cast ?? widget.contentItem.seriesStream?.cast;
    if (cast != null && cast.isNotEmpty) {
      details.add({
        'icon': Icons.people,
        'title': context.loc.cast,
        'value': cast,
      });
    }

    // Bölüm Süresi
    final episodeRunTime =
        seriesInfo?.episodeRunTime ??
            widget.contentItem.seriesStream?.episodeRunTime;
    if (episodeRunTime != null && episodeRunTime.isNotEmpty) {
      details.add({
        'icon': Icons.access_time,
        'title': context.loc.episode_duration,
        'value': '$episodeRunTime dakika',
      });
    }

    // Kategori ID
    final categoryId =
        seriesInfo?.categoryId ?? widget.contentItem.seriesStream?.categoryId;
    details.add({
      'icon': Icons.category,
      'title': context.loc.category_id,
      'value': categoryId ?? context.loc.not_found_in_category,
    });

    // Dizi ID
    final seriesIdValue =
        seriesInfo?.seriesId ??
            widget.contentItem.seriesStream?.seriesId.toString() ??
            widget.contentItem.id.toString();
    details.add({
      'icon': Icons.tag,
      'title': context.loc.series_id,
      'value': seriesIdValue,
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTrailerCard(),
        const SizedBox(height: 12),
        ...details.map((detail) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDetailCard(
            icon: detail['icon'],
            title: detail['title'],
            value: detail['value'],
          ),
        )).toList(),
      ],
    );
  }

  void _showSeasonEpisodes(SeasonsData season) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.neutral600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          season.name,
                          style: AppTypography.headline4,
                        ),
                      ),
                      Text(
                        context.loc.episode_count(
                          (season.episodeCount ?? 0).toString(),
                        ),
                        style: AppTypography.body2Regular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<EpisodesData>>(
                    future: _repository.getSeriesEpisodesBySeason(
                      seriesInfo?.seriesId ?? widget.contentItem.id.toString(),
                      season.seasonNumber,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final episodes = snapshot.data ?? [];
                      if (episodes.isEmpty) {
                        return Center(
                          child: Text(context.loc.not_found_in_category, style: AppTypography.body2Regular),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          final episode = episodes[index];
                          return _buildEpisodeCard(episode);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeCard(EpisodesData episode) {
    bool isRecent = false;
    if (episode.releasedate != null && episode.releasedate!.isNotEmpty) {
      try {
        final releaseDate = DateTime.parse(episode.releasedate!);
        final diff = DateTime.now().difference(releaseDate).inDays;
        isRecent = diff <= 15;
      } catch (e) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRecent
            ? AppColors.successGreen.withValues(alpha: 0.1)
            : AppColors.neutral500.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral600.withValues(alpha: 0.3), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeScreen(
                seriesInfo: seriesInfo,
                seasons: seasons,
                episodes: episodes,
                contentItem: ContentItem(
                  episode.episodeId,
                  episode.title,
                  episode.movieImage ?? "",
                  ContentType.series,
                  containerExtension: episode.containerExtension,
                  season: episode.season,
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                episode.movieImage != null && episode.movieImage!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    episode.movieImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          '${episode.episodeNum}',
                          style: AppTypography.body1SemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Text(
                    '${episode.episodeNum}',
                    style: AppTypography.body1SemiBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            episode.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.body2SemiBold,
                          ),
                        ),
                        if (isRecent)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child:  Text(
                              context.loc.new_ep,
                              style: AppTypography.body3SemiBold.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Süre bilgisi
                    if (episode.duration != null &&
                        episode.duration!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        context.loc.duration(episode.duration!),
                        style: AppTypography.body3Regular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],

                    // Plot
                    if (episode.plot != null && episode.plot!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        episode.plot!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body3Regular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (episode.rating != null && episode.rating! > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoYellow.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: AppColors.infoYellow, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            episode.rating!.toStringAsFixed(1),
                            style: AppTypography.body3SemiBold.copyWith(
                              color: AppColors.infoYellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final apiCover = seriesInfo?.cover;
    final apiBackdrop = seriesInfo?.backdropPath;

    final hasBackdrop =
        (apiBackdrop?.isNotEmpty == true) ||
            (widget.contentItem.seriesStream?.backdropPath?.isNotEmpty == true);
    final hasCover =
        (apiCover?.isNotEmpty == true) ||
            (widget.contentItem.seriesStream?.cover?.isNotEmpty == true);

    if (hasBackdrop || hasCover) {
      String? imageUrl;

      if (apiBackdrop?.isNotEmpty == true) {
        imageUrl = apiBackdrop;
      } else if (apiCover?.isNotEmpty == true) {
        imageUrl = apiCover;
      } else if (widget.contentItem.seriesStream?.backdropPath?.isNotEmpty ==
          true) {
        imageUrl = widget.contentItem.seriesStream!.backdropPath?[0];
      } else if (widget.contentItem.seriesStream?.cover?.isNotEmpty == true) {
        imageUrl = widget.contentItem.seriesStream!.cover;
      }

      if (imageUrl != null) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              color: AppColors.neutral500.withValues(alpha: 0.2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.neutral700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Görsel yükleniyor...',
                      // Bu string için de localization ekleyebiliriz
                      style: AppTypography.body2Regular.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      }
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.neutral500.withValues(alpha: 0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.neutral500.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tv_rounded, size: 64, color: AppColors.neutral700),
            ),
            const SizedBox(height: 16),
            Text(
              'Görsel Bulunamadı',
              // Bu string için de localization ekleyebiliriz
              style: AppTypography.body1Medium.copyWith(
                color: AppColors.neutral600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              seriesInfo?.name ?? widget.contentItem.name,
              textAlign: TextAlign.center,
              style: AppTypography.headline3.copyWith(
                color: AppColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral500.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral600.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.infoBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.infoBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body3Medium.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.body1SemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerCard() {
    final String? _trailerKey = seriesInfo?.youtubeTrailer;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        String urlString;
        if (_trailerKey != null && _trailerKey.isNotEmpty) {
          urlString = "https://www.youtube.com/watch?v=$_trailerKey";
        } else {
          final trailerText = context.loc.trailer;
          final languageCode = Localizations.localeOf(context).languageCode;
          final query = Uri.encodeQueryComponent("${widget.contentItem.name} $trailerText $languageCode");
          urlString = "https://www.youtube.com/results?search_query=$query";
        }

        final Uri url = Uri.parse(urlString);
        try {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (mounted) {
            ToastUtils.showError(context, context.loc.error_occurred_title);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral500.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral600.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.ondemand_video_rounded, size: 20, color: AppColors.errorPink),
            ),
            const SizedBox(width: 16),
            Text(
              context.loc.trailer,
              style: AppTypography.body1SemiBold,
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.neutral600),
          ],
        ),
      ),
    );
  }
}