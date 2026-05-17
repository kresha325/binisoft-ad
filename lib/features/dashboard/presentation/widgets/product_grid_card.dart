import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/storage_network_image.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/product_display_fields.dart';
import '../../../products/presentation/providers/attributes_providers.dart';

class ProductGridCard extends ConsumerWidget {
  const ProductGridCard({super.key, required this.product});

  final Product product;

  static const _imageHeight = 110.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
    final categories = ref.watch(categoriesListProvider).valueOrNull ?? [];
    final attributes = ref.watch(attributesListProvider).valueOrNull ?? [];
    final categoryNames = {for (final c in categories) c.id: c.name};
    final extraFields = buildProductCardExtraFields(
      product: product,
      categoryNames: categoryNames,
      attributes: attributes,
    );
    final description = product.description?.trim();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.card(context),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _imageHeight,
            width: double.infinity,
            child: imageUrl != null
                ? StorageNetworkImage(url: imageUrl, fit: BoxFit.cover)
                : _placeholder(colors),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description != null && description.isNotEmpty
                      ? description
                      : 'No description',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colors.textMuted.withValues(
                      alpha: description != null && description.isNotEmpty ? 1 : 0.7,
                    ),
                    fontStyle: description == null || description.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.basePrice != null
                            ? '\$${product.basePrice!.toStringAsFixed(2)}'
                            : '—',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.accent,
                        ),
                      ),
                    ),
                    _StatusDot(status: product.status),
                  ],
                ),
                if (extraFields.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Divider(height: 1, color: colors.cardBorder),
                  const SizedBox(height: 8),
                  for (final field in extraFields) ...[
                    _FieldRow(label: field.label, value: field.value),
                    const SizedBox(height: 4),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(AppColorScheme colors) {
    return Container(
      color: colors.surfaceElevated,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, size: 32, color: colors.textMuted),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final ProductStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (label, color) = switch (status) {
      ProductStatus.active => ('Active', colors.success),
      ProductStatus.draft => ('Draft', colors.textMuted),
      ProductStatus.archived => ('Archived', const Color(0xFFEA580C)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
