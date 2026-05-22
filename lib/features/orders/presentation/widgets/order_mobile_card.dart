import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../domain/entities/order.dart';
import 'order_status_chip.dart';

/// Touch-friendly order row for phones (replaces horizontal table scroll).
class OrderMobileCard extends StatelessWidget {
  const OrderMobileCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  final BusinessOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final date = DateFormat('d MMM, HH:mm').format(order.createdAt);
    final phone = order.customer.displayPhone;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                order.customer.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
              if (phone.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                order.productsSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.textMuted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '€${order.subtotalEur.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.accent,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 20, color: colors.textMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
