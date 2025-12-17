import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/feature/premium/presentation/pages/browse_content_screen.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:flutter/material.dart';

class WatchHistoryAppBar extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onClearAll;
  final VoidCallback? onRefreshFavorites;

  const WatchHistoryAppBar({super.key, this.onRefresh, this.onClearAll, this.onRefreshFavorites});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
   
      title: SelectableText(context.loc.history, style: AppTypography.body1SemiBold),
      floating: true,
      snap: true,
      elevation: 0,
      actions: [
         AppButton(
           text: 'Pro',
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const BrowseContentScreen()),
             );
           },
           style: AppButtonStyleEnum.accentGradient,
         ),
        PopupMenuButton<String>(
          onSelected: (action) => _handleMenuAction(action, context),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [Icon(Icons.refresh), SizedBox(width: 8), Text(context.loc.refresh)],
              ),
            ),
            PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    context.loc.clear_all,
                    style: AppTypography.body2Regular.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'refresh':
        onRefresh?.call();
        onRefreshFavorites?.call();
        break;
      case 'clear_all':
        _onClearAllTap(context);
        break;
    }
  }

  void _onClearAllTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc.clear_all),
        content: Text(context.loc.clear_all_confirmation_message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.loc.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClearAll?.call();
            },
            child: Text(
              context.loc.delete,
              style: AppTypography.body2Regular.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
