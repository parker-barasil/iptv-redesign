import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/utils/get_playlist_type.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import '../../../controllers/favorites_controller.dart';
import '../../../models/favorite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/player_widget.dart';
import '../../utils/toast_utils.dart';

class MovieScreen extends StatefulWidget {
  final ContentItem contentItem;

  const MovieScreen({super.key, required this.contentItem});

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late FavoritesController _favoritesController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _favoritesController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlayerWidget(contentItem: widget.contentItem),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.contentItem.name,
                              style: AppTypography.headline3,
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleFavorite,
                            icon: Icon(
                              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: _isFavorite ? AppColors.errorPink : AppColors.neutral600,
                              size: 28,
                            ),
                          ),
                          if (isXtreamCode)
                            ...List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  index <
                                          (widget
                                                  .contentItem
                                                  .vodStream!
                                                  .rating5based
                                                  .round() ??
                                              0)
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: AppColors.infoYellow,
                                  size: 24,
                                ),
                              );
                            }),
                          const SizedBox(width: 12),
                          if (isXtreamCode)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.infoYellow.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${widget.contentItem.vodStream!.rating5based.toStringAsFixed(1) ?? '0.0'}/5',
                                style: AppTypography.body2SemiBold.copyWith(
                                  color: AppColors.infoYellow,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      _buildTrailerCard(),

                      const SizedBox(height: 12),
                      _buildDetailCard(
                        icon: Icons.calendar_today,
                        title: context.loc.creation_date,
                        value: _formatDate('1746225795', context),
                      ),
                      const SizedBox(height: 12),

                      _buildDetailCard(
                        icon: Icons.category,
                        title: context.loc.category_id,
                        value:
                            widget.contentItem.vodStream?.categoryId ??
                            context.loc.not_found_in_category,
                      ),
                      const SizedBox(height: 12),

                      _buildDetailCard(
                        icon: Icons.tag,
                        title: context.loc.stream_id_label,
                        value: widget.contentItem.id.toString(),
                      ),
                      const SizedBox(height: 12),

                      _buildDetailCard(
                        icon: Icons.video_file,
                        title: context.loc.format,
                        value:
                            widget.contentItem.containerExtension
                                ?.toUpperCase() ??
                            context.loc.unknown,
                      ),
                      const SizedBox(height: 12),
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

  String _formatDate(String? timestamp, BuildContext context) {
    if (timestamp == null) return context.loc.unknown;
    try {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp) * 1000,
      );
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return context.loc.unknown;
    }
  }

  Widget _buildTrailerCard() {
    final String? _trailerKey = widget.contentItem.vodStream?.youtubeTrailer;

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
