import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color_scheme.dart';

/// Responsive grid of [CatalogEntityCard] widgets.
class CatalogCardGrid extends StatelessWidget {
  const CatalogCardGrid({
    super.key,
    required this.children,
    this.emptyMessage = 'No items found.',
    this.minHeight = 220,
    this.scrollable = false,
  });

  final List<Widget> children;
  final String emptyMessage;
  final double minHeight;
  /// When true (e.g. superadmin tabs), grid scrolls inside [Expanded].
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (children.isEmpty) {
      return SizedBox(
        height: minHeight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 40, color: colors.textMuted.withValues(alpha: 0.6)),
              const SizedBox(height: 12),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 15, color: colors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 1100
            ? 3
            : width > 680
                ? 2
                : 1;

        final grid = GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: crossAxisCount == 1 ? 2.4 : 1.05,
          shrinkWrap: !scrollable,
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          children: children,
        );

        if (scrollable) return grid;
        return grid;
      },
    );
  }
}
