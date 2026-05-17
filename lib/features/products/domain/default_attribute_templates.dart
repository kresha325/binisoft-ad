import 'package:collection/collection.dart';

import 'entities/attribute_definition.dart';

/// Predefined product fields a business can enable with one tap.
class DefaultAttributeTemplate {
  const DefaultAttributeTemplate({
    required this.name,
    required this.key,
    required this.type,
    this.options = const [],
    this.description,
  });

  final String name;
  final String key;
  final AttributeType type;
  final List<String> options;
  final String? description;
}

const defaultAttributeTemplates = <DefaultAttributeTemplate>[
  DefaultAttributeTemplate(
    name: 'Brand',
    key: 'brand',
    type: AttributeType.text,
    description: 'Product brand or manufacturer name',
  ),
  DefaultAttributeTemplate(
    name: 'Material',
    key: 'material',
    type: AttributeType.text,
    description: 'Primary material (e.g. cotton, leather)',
  ),
  DefaultAttributeTemplate(
    name: 'Size',
    key: 'size',
    type: AttributeType.select,
    options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    description: 'Standard size',
  ),
  DefaultAttributeTemplate(
    name: 'Color',
    key: 'color',
    type: AttributeType.color,
    description: 'Product color',
  ),
  DefaultAttributeTemplate(
    name: 'Weight',
    key: 'weight',
    type: AttributeType.number,
    description: 'Weight in kg',
  ),
  DefaultAttributeTemplate(
    name: 'SKU',
    key: 'sku',
    type: AttributeType.text,
    description: 'Stock keeping unit / product code',
  ),
  DefaultAttributeTemplate(
    name: 'Barcode',
    key: 'barcode',
    type: AttributeType.text,
    description: 'EAN / UPC barcode',
  ),
  DefaultAttributeTemplate(
    name: 'Dimensions',
    key: 'dimensions',
    type: AttributeType.text,
    description: 'L × W × H',
  ),
  DefaultAttributeTemplate(
    name: 'Warranty',
    key: 'warranty',
    type: AttributeType.text,
    description: 'Warranty period or terms',
  ),
  DefaultAttributeTemplate(
    name: 'Country of Origin',
    key: 'country_of_origin',
    type: AttributeType.text,
    description: 'Where the product is made',
  ),
];

bool isDefaultTemplateEnabled(
  DefaultAttributeTemplate template,
  List<AttributeDefinition> attributes,
) {
  final match = attributes.where((a) => a.key == template.key).firstOrNull;
  return match != null && match.active && match.required;
}
