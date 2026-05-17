import 'package:equatable/equatable.dart';

enum AttributeType {
  text,
  textarea,
  number,
  select,
  multiSelect,
  color,
  boolean,
}

class AttributeDefinition extends Equatable {
  const AttributeDefinition({
    required this.id,
    required this.businessId,
    required this.name,
    required this.key,
    required this.type,
    required this.required,
    this.options = const [],
    this.active = true,
    this.nameI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String key;
  final AttributeType type;
  final bool required;
  final List<String> options;
  final bool active;
  final Map<String, String> nameI18n;

  AttributeDefinition copyWith({
    String? name,
    String? key,
    AttributeType? type,
    bool? required,
    List<String>? options,
    bool? active,
    Map<String, String>? nameI18n,
  }) {
    return AttributeDefinition(
      id: id,
      businessId: businessId,
      name: name ?? this.name,
      key: key ?? this.key,
      type: type ?? this.type,
      required: required ?? this.required,
      options: options ?? this.options,
      active: active ?? this.active,
      nameI18n: nameI18n ?? this.nameI18n,
    );
  }

  @override
  List<Object?> get props =>
      [id, businessId, name, key, type, required, options, active, nameI18n];
}
