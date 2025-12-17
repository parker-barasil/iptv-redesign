import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:flutter/material.dart';

class WatchHistoryEmptyState extends StatelessWidget {
  const WatchHistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final subtleColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: subtleColor),
          const SizedBox(height: 16),
          Text(
            context.loc.history,
            style: AppTypography.headline3.copyWith(
              color: subtleColor,
            ),
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
    );
  }
}
