import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/offer.dart';
import 'offer_sheet_helpers.dart';

class ProductOfferDiscountCard extends StatelessWidget {
  const ProductOfferDiscountCard({
    super.key,
    required this.product,
    required this.selected,
    required this.draft,
    required this.onSelectedChanged,
    required this.onDraftChanged,
    this.lockSelection = false,
  });

  final Product product;
  final bool selected;
  final ProductDiscountDraft? draft;
  final ValueChanged<bool> onSelectedChanged;
  final VoidCallback onDraftChanged;
  /// Edit mode: only this offer's products, no catalog multi-select.
  final bool lockSelection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final base = product.basePrice ?? 0;
    final thumb = product.images.isNotEmpty ? product.images.first.url : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (lockSelection)
              _productHeader(colors, thumb, base)
            else
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: selected,
                onChanged: (v) => onSelectedChanged(v == true),
                title: _productHeader(colors, thumb, base),
              ),
            if ((lockSelection || selected) && draft != null) ...[
              const SizedBox(height: 8),
              SegmentedButton<OfferDiscountMode>(
                segments: [
                  ButtonSegment(
                    value: OfferDiscountMode.percent,
                    label: Text(l10n.offerModePercent),
                  ),
                  ButtonSegment(
                    value: OfferDiscountMode.salePrice,
                    label: Text(l10n.offerModeSalePrice),
                  ),
                ],
                selected: {draft!.mode},
                onSelectionChanged: (s) {
                  draft!.mode = s.first;
                  onDraftChanged();
                },
              ),
              const SizedBox(height: 8),
              if (draft!.mode == OfferDiscountMode.percent)
                TextFormField(
                  key: ValueKey('pct-${product.id}-${draft!.percent}'),
                  initialValue: draft!.percent.toStringAsFixed(0),
                  decoration: InputDecoration(
                    labelText: l10n.offerPercentLabel,
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    draft!.percent =
                        double.tryParse(v.replaceAll(',', '.')) ?? 0;
                    onDraftChanged();
                  },
                )
              else
                TextFormField(
                  key: ValueKey('price-${product.id}-${draft!.salePrice}'),
                  initialValue: (draft!.salePrice ?? base).toStringAsFixed(2),
                  decoration: InputDecoration(
                    labelText: l10n.offerSalePriceLabel,
                    prefixText: '€ ',
                    helperText: '${l10n.productPriceLabel}: €${base.toStringAsFixed(2)}',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) {
                    draft!.salePrice = double.tryParse(v.replaceAll(',', '.'));
                    onDraftChanged();
                  },
                ),
              if (draft!.resolvedSalePrice() != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.offerResultPrice(draft!.resolvedSalePrice()!.toStringAsFixed(2)),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _productHeader(AppColorScheme colors, String? thumb, double base) {
    return Row(
      children: [
        if (thumb != null && thumb.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              thumb,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _thumbPlaceholder(colors),
            ),
          ),
          const SizedBox(width: 12),
        ] else
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _thumbPlaceholder(colors),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              Text(
                '€${base.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumbPlaceholder(AppColorScheme colors) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Icon(Icons.inventory_2_outlined, color: colors.textMuted, size: 22),
    );
  }
}
