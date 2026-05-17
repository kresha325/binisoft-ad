import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../domain/entities/order_line.dart';

/// Lists each ordered product with quantity (for orders table & dashboard).
class OrderProductLinesCell extends StatelessWidget {
  const OrderProductLinesCell({
    super.key,
    required this.lines,
    this.namesOnly = false,
    this.quantitiesOnly = false,
    this.maxWidth = 200,
  });

  final List<OrderLine> lines;
  final bool namesOnly;
  final bool quantitiesOnly;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (lines.isEmpty) {
      return Text('—', style: TextStyle(color: colors.textMuted, fontSize: 13));
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) const SizedBox(height: 6),
            if (quantitiesOnly)
              _qtyBadge(lines[i].quantity, colors)
            else if (namesOnly)
              Text(
                lines[i].productName,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      lines[i].productName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _qtyBadge(lines[i].quantity, colors),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _qtyBadge(int qty, AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '×$qty',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: colors.accent,
        ),
      ),
    );
  }
}
