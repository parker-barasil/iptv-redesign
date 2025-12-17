import 'package:flutter/material.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';

class DropdownTileWidget<T> extends StatelessWidget {
  final IconData icon;
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const DropdownTileWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, size: 20),
      title: Text(
        label,
        style: AppTypography.body2Medium,
      ),
      trailing: SizedBox(
        width: 120,
        child: DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          style: AppTypography.body3Regular,
          dropdownColor: Theme.of(context).colorScheme.surface,
          icon: Icon(Icons.keyboard_arrow_down, size: 18),
        ),
      ),
    );
  }
}
