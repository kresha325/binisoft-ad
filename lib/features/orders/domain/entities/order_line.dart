import 'package:equatable/equatable.dart';

class OrderLine extends Equatable {
  const OrderLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceEur,
    required this.lineTotalEur,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPriceEur;
  final double lineTotalEur;

  @override
  List<Object?> get props =>
      [productId, productName, quantity, unitPriceEur, lineTotalEur];
}
