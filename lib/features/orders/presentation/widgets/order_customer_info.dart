import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../domain/entities/order.dart';

class OrderCustomerInfo extends StatelessWidget {
  const OrderCustomerInfo({
    super.key,
    required this.customer,
    this.showName = true,
  });

  final OrderCustomer customer;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final phone = customer.displayPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showName)
          Text(
            customer.name,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        if (phone.isNotEmpty) ...[
          if (showName) const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _callPhone(context, phone),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_outlined, size: 14, color: colors.accent),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        phone,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.accent.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ] else if (showName)
          Text(
            context.l10n.orderNoPhone,
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
          ),
      ],
    );
  }

  Future<void> _callPhone(BuildContext context, String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: '+$digits');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.orderDialerFailed(phone))),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.orderDialerFailed(phone))),
        );
      }
    }
  }
}
