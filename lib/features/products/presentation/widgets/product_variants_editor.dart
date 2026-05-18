import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/attribute_definition.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/variant_combinator.dart';

/// Editable variant row before save.
class VariantDraft {
  VariantDraft({
    this.id = '',
    required this.attributes,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  String id;
  final Map<String, String> attributes;
  String sku;
  double price;
  int quantity;

  ProductVariant toEntity({
    required String productId,
    required String businessId,
  }) =>
      ProductVariant(
        id: id,
        productId: productId,
        businessId: businessId,
        sku: sku,
        price: price,
        quantity: quantity,
        attributes: Map<String, String>.from(attributes),
      );

  static VariantDraft fromEntity(ProductVariant v) => VariantDraft(
        id: v.id,
        attributes: Map<String, String>.from(v.attributes),
        sku: v.sku,
        price: v.price,
        quantity: v.quantity,
      );
}

class ProductVariantsEditor extends StatefulWidget {
  const ProductVariantsEditor({
    super.key,
    required this.selectAttributes,
    required this.productSlug,
    required this.basePrice,
    this.initialVariants = const [],
    required this.onChanged,
  });

  final List<AttributeDefinition> selectAttributes;
  final String productSlug;
  final double basePrice;
  final List<ProductVariant> initialVariants;
  final ValueChanged<List<VariantDraft>> onChanged;

  @override
  State<ProductVariantsEditor> createState() => _ProductVariantsEditorState();
}

class _ProductVariantsEditorState extends State<ProductVariantsEditor> {
  final Set<String> _axisKeys = {};
  late List<VariantDraft> _drafts;

  @override
  void initState() {
    super.initState();
    _drafts = widget.initialVariants.map(VariantDraft.fromEntity).toList();
    for (final v in widget.initialVariants) {
      _axisKeys.addAll(v.attributes.keys);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  @override
  void didUpdateWidget(covariant ProductVariantsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialVariants != widget.initialVariants &&
        widget.initialVariants.isNotEmpty &&
        _drafts.isEmpty) {
      _drafts = widget.initialVariants.map(VariantDraft.fromEntity).toList();
      for (final v in widget.initialVariants) {
        _axisKeys.addAll(v.attributes.keys);
      }
      _notify();
    }
  }

  void _notify() => widget.onChanged(List<VariantDraft>.from(_drafts));

  List<AttributeDefinition> get _eligibleAxes => widget.selectAttributes
      .where((a) => a.type == AttributeType.select && a.options.length >= 2)
      .toList();

  void _generate() {
    if (_axisKeys.isEmpty) return;

    final axes = <String, List<String>>{};
    for (final attr in _eligibleAxes) {
      if (_axisKeys.contains(attr.key)) {
        axes[attr.key] = List<String>.from(attr.options);
      }
    }
    if (axes.isEmpty) return;

    final combos = generateVariantCombinations(axes);
    final slug = widget.productSlug.isNotEmpty ? widget.productSlug : 'product';

    setState(() {
      _drafts = combos
          .map(
            (attrs) => VariantDraft(
              attributes: attrs,
              sku: buildSku(slug, attrs),
              price: widget.basePrice,
              quantity: 0,
            ),
          )
          .toList();
    });
    _notify();
  }

  String _rowLabel(VariantDraft draft) {
    final l10n = context.l10n;
    final parts = <String>[];
    for (final attr in _eligibleAxes) {
      final value = draft.attributes[attr.key];
      if (value != null && value.isNotEmpty) {
        parts.add('${attr.name}: $value');
      }
    }
    return l10n.variantsRowLabel(parts.join(' · '));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final axes = _eligibleAxes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.variantsSectionTitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.variantsSectionSubtitle,
          style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
        ),
        const SizedBox(height: 14),
        if (axes.isEmpty)
          Text(
            l10n.variantsNoAxes,
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.35),
          )
        else ...[
          Text(
            l10n.variantsSelectAxes,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final attr in axes)
                FilterChip(
                  label: Text(attr.name),
                  selected: _axisKeys.contains(attr.key),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _axisKeys.add(attr.key);
                      } else {
                        _axisKeys.remove(attr.key);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: _axisKeys.isEmpty ? null : _generate,
                icon: const Icon(Icons.auto_fix_high_outlined, size: 18),
                label: Text(l10n.variantsGenerate),
              ),
              if (_drafts.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      for (final d in _drafts) {
                        d.price = widget.basePrice;
                      }
                    });
                    _notify();
                  },
                  icon: const Icon(Icons.euro_rounded, size: 18),
                  label: Text(l10n.variantsApplyBasePrice),
                ),
              if (_drafts.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() => _drafts = []);
                    _notify();
                  },
                  icon: const Icon(Icons.clear_all_rounded, size: 18),
                  label: Text(l10n.variantsClear),
                ),
            ],
          ),
        ],
        if (_drafts.isNotEmpty) ...[
          const SizedBox(height: 16),
          for (var i = 0; i < _drafts.length; i++) ...[
            _VariantRowCard(
              title: _rowLabel(_drafts[i]),
              draft: _drafts[i],
              skuLabel: l10n.variantsSku,
              priceLabel: l10n.variantsPrice,
              qtyLabel: l10n.variantsQuantity,
              onChanged: () {
                setState(() {});
                _notify();
              },
            ),
            if (i < _drafts.length - 1) const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

class _VariantRowCard extends StatefulWidget {
  const _VariantRowCard({
    required this.title,
    required this.draft,
    required this.skuLabel,
    required this.priceLabel,
    required this.qtyLabel,
    required this.onChanged,
  });

  final String title;
  final VariantDraft draft;
  final String skuLabel;
  final String priceLabel;
  final String qtyLabel;
  final VoidCallback onChanged;

  @override
  State<_VariantRowCard> createState() => _VariantRowCardState();
}

class _VariantRowCardState extends State<_VariantRowCard> {
  late final TextEditingController _skuController;
  late final TextEditingController _priceController;
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.draft.sku);
    _priceController = TextEditingController(text: widget.draft.price.toString());
    _qtyController = TextEditingController(text: widget.draft.quantity.toString());
  }

  @override
  void dispose() {
    _skuController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final draft = widget.draft;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: widget.skuLabel,
            controller: _skuController,
            onChanged: (v) {
              draft.sku = v.trim();
              widget.onChanged();
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: widget.priceLabel,
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) {
                    draft.price = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                    widget.onChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: widget.qtyLabel,
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    draft.quantity = int.tryParse(v.trim()) ?? 0;
                    widget.onChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
