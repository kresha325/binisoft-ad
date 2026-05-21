import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TableRowActions extends StatelessWidget {
  const TableRowActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
    this.onViewEntries,
    this.viewEntriesTooltip,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onViewEntries;
  final String? viewEntriesTooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onViewEntries != null)
          IconButton(
            tooltip: viewEntriesTooltip ?? 'Entries',
            icon: const Icon(Icons.people_outline, size: 20),
            color: AppColors.navy,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: onViewEntries,
          ),
        IconButton(
          tooltip: 'Edit',
          icon: const Icon(Icons.edit_outlined, size: 20),
          color: AppColors.navy,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: onEdit,
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline, size: 20),
          color: const Color(0xFFDC2626),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
