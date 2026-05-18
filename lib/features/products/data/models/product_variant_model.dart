import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_variant.dart';

class ProductVariantModel {
  ProductVariantModel({
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

  factory ProductVariantModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final rawAttrs = data['attributes'];
    final attributes = <String, String>{};
    if (rawAttrs is Map) {
      for (final entry in rawAttrs.entries) {
        attributes[entry.key.toString()] = entry.value.toString();
      }
    }

    return ProductVariantModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      businessId: data['businessId'] as String? ?? '',
      sku: data['sku'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      imageUrl: data['imageUrl'] as String?,
      attributes: attributes,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'businessId': businessId,
        'sku': sku,
        'price': price,
        'quantity': quantity,
        if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
        'attributes': attributes,
      };

  ProductVariant toEntity() => ProductVariant(
        id: id,
        productId: productId,
        businessId: businessId,
        sku: sku,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
        attributes: attributes,
      );

  static ProductVariantModel fromEntity(ProductVariant v) => ProductVariantModel(
        id: v.id,
        productId: v.productId,
        businessId: v.businessId,
        sku: v.sku,
        price: v.price,
        quantity: v.quantity,
        imageUrl: v.imageUrl,
        attributes: v.attributes,
      );
}
