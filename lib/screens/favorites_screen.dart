import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/feature/premium/presentation/pages/browse_content_screen.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/repositories/favorites_repository.dart';
import 'package:another_iptv_player/widgets/content_card.dart';
import 'package:another_iptv_player/utils/navigate_by_content_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/controllers/favorites_controller.dart';
import 'package:another_iptv_player/utils/toast_utils.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  final String playlistId;

  const FavoritesScreen({super.key, required this.playlistId});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoritesRepository = FavoritesRepository();
  final _favoritesController = FavoritesController();
  List<Favorite> _favorites = [];
  Map<String, ContentItem> _contentItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favorites = await _favoritesRepository.getAllFavorites();

    // Load all content items upfront
    final Map<String, ContentItem> contentItems = {};
    for (final favorite in favorites) {
      final contentItem = await _favoritesRepository.getContentItemFromFavorite(favorite);
      contentItems[favorite.streamId] =
          contentItem ??
          ContentItem(
            favorite.streamId,
            favorite.name,
            favorite.imagePath ?? '',
            favorite.contentType,
          );
    }

    if (mounted) {
      setState(() {
        _favorites = favorites;
        _contentItems = contentItems;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Favorite favorite, int index) async {
    // Удаление из базы данных
    final success = await _favoritesController.removeFavorite(
      favorite.streamId,
      favorite.contentType,
      episodeId: favorite.episodeId,
    );

    if (success && mounted) {
      setState(() {
        _favorites.removeAt(index);
        _contentItems.remove(favorite.streamId);
      });
      ToastUtils.showSuccess(context, context.loc.removed_from_favorites);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.favorites),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppButton(
              text: 'Pro',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrowseContentScreen()),
                );
              },
              style: AppButtonStyleEnum.accentGradient,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final subtleColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: subtleColor),
          const SizedBox(height: 16),
          Text(
            context.loc.favorites,
            style: AppTypography.headline3.copyWith(color: subtleColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.loc.no_favorites_yet,
            style: AppTypography.body2Regular.copyWith(color: subtleColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        return AnimatedSize(
          key: ValueKey(favorite.streamId),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: _buildFavoriteCard(favorite, index),
        );
      },
    );
  }

  Widget _buildFavoriteCard(Favorite favorite, int index) {
    final contentItem =
        _contentItems[favorite.streamId] ??
        ContentItem(
          favorite.streamId,
          favorite.name,
          favorite.imagePath ?? '',
          favorite.contentType,
        );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ContentCard(
                  content: contentItem,
                  width: constraints.maxWidth,
                  onTap: () => navigateByContentType(context, contentItem),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _AnimatedDeleteButton(onTap: () => _removeFavorite(favorite, index)),
            ),
          ],
        ),
      ),
    );
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
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.errorPink,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.remove, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
