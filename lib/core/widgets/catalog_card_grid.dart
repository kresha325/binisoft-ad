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
    /// Taller cells for cards with footer actions (contests, job openings).
    this.tallCells = false,
  });

  final List<Widget> children;
  final String emptyMessage;
  final double minHeight;
  /// When true (e.g. superadmin tabs), grid scrolls inside [Expanded].
  final bool scrollable;
  final bool tallCells;

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
        final crossAxisCount = width > 1280
            ? 4
            : width > 960
                ? 3
                : width > 560
                    ? 2
                    : 1;

        // Compact cards ~88–96px; tallCells fits footer buttons (contests, jobs).
        final childAspectRatio = tallCells
            ? switch (crossAxisCount) {
                4 => 1.55,
                3 => 1.4,
                2 => 1.25,
                _ => 1.05,
              }
            : switch (crossAxisCount) {
                4 => 3.5,
                3 => 3.2,
                2 => 2.85,
                _ => 2.4,
              };

        final grid = GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: childAspectRatio,
          shrinkWrap: !scrollable,
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          clipBehavior: tallCells ? Clip.none : Clip.hardEdge,
          children: children,
        );

        if (scrollable) return grid;
        return grid;
      },
    );
  }
}
