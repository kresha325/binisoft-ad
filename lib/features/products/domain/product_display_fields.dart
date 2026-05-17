import 'entities/attribute_definition.dart';
import 'entities/product.dart';
import 'preset_colors.dart';

class ProductDisplayField {
  const ProductDisplayField({required this.label, required this.value});

  final String label;
  final String value;
}

String formatAttributeValue(dynamic value, [AttributeType? type]) {
  if (value == null) return '—';
  if (value is bool) return value ? 'Yes' : 'No';
  if (value is List) {
    return value.map((e) => e.toString()).where((s) => s.isNotEmpty).join(', ');
  }
  if (type == AttributeType.color) {
    final color = SelectedProductColor.fromDynamic(value);
    if (color != null) {
      if (color.name.isNotEmpty && color.hex.isNotEmpty) {
        return '${color.name} (${color.hex})';
      }
      return color.name.isNotEmpty ? color.name : color.hex;
    }
  }
  return value.toString();
}

String productStatusLabel(ProductStatus status) => switch (status) {
      ProductStatus.active => 'Active',
      ProductStatus.draft => 'Draft',
      ProductStatus.archived => 'Archived',
    };

/// All product fields for cards / previews (core + custom attributes).
List<ProductDisplayField> buildProductDisplayFields({
  required Product product,
  required Map<String, String> categoryNames,
  required List<AttributeDefinition> attributes,
}) {
  final fields = <ProductDisplayField>[
    ProductDisplayField(label: 'Slug', value: product.slug),
    ProductDisplayField(label: 'Status', value: productStatusLabel(product.status)),
    ProductDisplayField(
      label: 'Price',
      value: product.basePrice != null
          ? '\$${product.basePrice!.toStringAsFixed(2)}'
          : '—',
    ),
  ];

  if (product.categoryIds.isNotEmpty) {
    final names = product.categoryIds
        .map((id) => categoryNames[id] ?? id)
        .join(', ');
    fields.add(ProductDisplayField(label: 'Category', value: names));
  }

  if (product.imageUrls.length > 1) {
    fields.add(
      ProductDisplayField(
        label: 'Images',
        value: '${product.imageUrls.length} image URLs',
      ),
    );
  }

  final shownKeys = <String>{};
  for (final attr in attributes.where((a) => a.active)) {
    if (product.attributeData.containsKey(attr.key)) {
      shownKeys.add(attr.key);
      fields.add(
        ProductDisplayField(
          label: attr.name,
          value: formatAttributeValue(product.attributeData[attr.key], attr.type),
        ),
      );
    }
  }

  for (final entry in product.attributeData.entries) {
    if (shownKeys.contains(entry.key)) continue;
    fields.add(
      ProductDisplayField(
        label: entry.key,
        value: formatAttributeValue(entry.value),
      ),
    );
  }

  return fields;
}

/// Category + custom attributes — shown below description on cards (no slug/status/price/quantity).
List<ProductDisplayField> buildProductCardExtraFields({
  required Product product,
  required Map<String, String> categoryNames,
  required List<AttributeDefinition> attributes,
}) {
  return buildProductDisplayFields(
    product: product,
    categoryNames: categoryNames,
    attributes: attributes,
  ).where((f) => !{'Slug', 'Status', 'Price', 'Quantity'}.contains(f.label)).toList();
}
