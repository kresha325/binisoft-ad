import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class DataTableCard extends StatelessWidget {
  const DataTableCard({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'No data found.',
    this.minHeight = 220,
  });

  final List<String> columns;
  final List<DataRow> rows;
  final String emptyMessage;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = AppBreakpoints.isMobile(context);
    final hMargin = isMobile ? 14.0 : 22.0;
    final colSpacing = isMobile ? 16.0 : 28.0;

    return SizedBox(
      width: double.infinity,
      child: GlassSurface(
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: rows.isEmpty
          ? SizedBox(
              height: minHeight,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 40, color: colors.textMuted.withValues(alpha: 0.6)),
                    const SizedBox(height: 12),
                    Text(
                      emptyMessage,
                      style: GoogleFonts.inter(fontSize: 15, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final table = DataTable(
                  headingRowHeight: 48,
                  dataRowMinHeight: 54,
                  dataRowMaxHeight: 76,
                  horizontalMargin: hMargin,
                  columnSpacing: colSpacing,
                  headingRowColor: WidgetStateProperty.all(colors.tableHeaderBg),
                  dividerThickness: 0.5,
                  columns: [
                    for (final c in columns)
                      DataColumn(
                        label: Text(
                          c.toUpperCase(),
                          style: AppTextStyles.tableHeader(context),
                        ),
                      ),
                  ],
                  rows: rows,
                );

                final horizontalTable = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: table,
                  ),
                );

                final hasBoundedHeight =
                    constraints.hasBoundedHeight && constraints.maxHeight.isFinite;

                if (!hasBoundedHeight) {
                  return horizontalTable;
                }

                return Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: horizontalTable,
                  ),
                );
              },
            ),
      ),
    );
  }
}
