import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';

class InfoTileWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const InfoTileWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(label, style: AppTypography.body3Regular),
      subtitle: Text(
        value,
        style: AppTypography.body2Regular.copyWith(color: valueColor),
      ),
      dense: true,
    );
  }
}