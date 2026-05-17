import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.businessId,
    required this.sku,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.attributes = const {},
  });

  final String id;
  final String productId;
  final String businessId;
  final String sku;
  final double price;
  final int quantity;
  final String? imageUrl;
  final Map<String, String> attributes;

  @override
  List<Object?> get props =>
      [id, productId, businessId, sku, price, quantity, imageUrl, attributes];
}
