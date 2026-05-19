import 'package:equatable/equatable.dart';

/// Bookable / sellable service in the business catalog.
class BusinessService extends Equatable {
  const BusinessService({
    required this.id,
    required this.businessId,
    required this.name,
    required this.slug,
    required this.order,
    this.description,
    this.durationMinutes,
    this.priceEur,
    this.active = true,
    this.nameI18n = const {},
    this.descriptionI18n = const {},
  });

  final String id;
  final String businessId;
  final String name;
  final String slug;
  final int order;
  final String? description;
  final int? durationMinutes;
  final double? priceEur;
  final bool active;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;

  String? get durationLabel {
    final m = durationMinutes;
    if (m == null || m <= 0) return null;
    if (m < 60) return '${m}m';
    final h = m ~/ 60;
    final rest = m % 60;
    if (rest == 0) return '${h}h';
    return '${h}h ${rest}m';
  }

  String? get priceLabel {
    final p = priceEur;
    if (p == null || p <= 0) return null;
    return '€${p.toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        slug,
        order,
        description,
        durationMinutes,
        priceEur,
        active,
        nameI18n,
        descriptionI18n,
      ];
}
