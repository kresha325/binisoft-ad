import 'entities/attribute_definition.dart';

bool attributeValueIsSet(dynamic value) {
  if (value == null) return false;
  if (value is Map) {
    return value.values.any((v) => v != null && v.toString().trim().isNotEmpty);
  }
  if (value is String) return value.trim().isNotEmpty;
  if (value is List) return value.isNotEmpty;
  return true;
}

/// Returns an error message when a required custom field is missing.
String? validateRequiredAttributes(
  List<AttributeDefinition> attributes,
  Map<String, dynamic> values,
) {
  for (final attr in attributes.where((a) => a.active && a.required)) {
    if (!attributeValueIsSet(values[attr.key])) {
      return '${attr.name} is required';
    }
  }
  return null;
}

Map<String, dynamic> serializeAttributeData(
  List<AttributeDefinition> attributes,
  Map<String, dynamic> values,
) {
  final result = <String, dynamic>{};
  for (final attr in attributes.where((a) => a.active)) {
    final value = values[attr.key];
    if (!attributeValueIsSet(value)) continue;
    if (attr.type == AttributeType.color && value is Map) {
      result[attr.key] = Map<String, dynamic>.from(value);
      continue;
    }
    if (attr.type == AttributeType.number) {
      if (value is num) {
        result[attr.key] = value;
      } else {
        final parsed = num.tryParse(value.toString().trim());
        if (parsed != null) result[attr.key] = parsed;
      }
    } else if (value is String) {
      result[attr.key] = value.trim();
    } else {
      result[attr.key] = value;
    }
  }
  return result;
}
