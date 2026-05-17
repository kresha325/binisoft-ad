import 'entities/attribute_definition.dart';

extension AttributeTypeLabels on AttributeType {
  String get label => switch (this) {
        AttributeType.text => 'Text (Short)',
        AttributeType.textarea => 'Text (Long)',
        AttributeType.number => 'Number',
        AttributeType.select => 'Select',
        AttributeType.multiSelect => 'Multi Select',
        AttributeType.color => 'Color',
        AttributeType.boolean => 'Boolean',
      };

  static AttributeType fromLabel(String label) {
    return AttributeType.values.firstWhere(
      (t) => t.label == label,
      orElse: () => AttributeType.text,
    );
  }
}
