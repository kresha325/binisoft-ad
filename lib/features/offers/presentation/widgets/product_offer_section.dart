import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../products/domain/entities/product.dart';
import '../providers/offers_providers.dart';
import 'add_offer_sheet.dart';
import 'offer_sheet_helpers.dart';

/// Ofertë e shpejtë nga faqja e editimit të produktit.
class ProductOfferSection extends ConsumerWidget {
  const ProductOfferSection({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final offers = ref.watch(offersListProvider).valueOrNull ?? [];
    final existing = activeOfferContaining(offers, product.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.navOffers,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        if (product.isOnOfferHold) ...[
          Text(
            'Vetëm në ofertë aktive — në menu shfaqet si Draft derisa oferta skadon.',
            style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
          ),
        ] else if (existing != null) ...[
          Text(
            l10n.productAlreadyOnOffer(existing.title),
            style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => showOfferSheet(context, ref, offer: existing),
            icon: const Icon(Icons.local_offer_outlined, size: 20),
            label: Text(l10n.productEditOffer),
          ),
        ] else
          FilledButton.icon(
            onPressed: product.status == ProductStatus.active && !product.isOnOfferHold
                ? () => showQuickOfferForProduct(context, ref, product: product)
                : null,
            icon: const Icon(Icons.local_offer_outlined, size: 20),
            label: Text(l10n.productPutOnOffer),
          ),
      ],
    );
  }
}
