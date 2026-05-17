import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.order,
    this.parentId,
    this.description,
    this.nameI18n = const {},
    this.descriptionI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final int order;
  final String? parentId;
  final String? description;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        slug,
        order,
        parentId,
        description,
        nameI18n,
        descriptionI18n,
      ];
}
