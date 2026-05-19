import 'package:equatable/equatable.dart';

/// Public shop: cart + checkout fields toggled from Settings.
class ShopCheckoutConfig extends Equatable {
  const ShopCheckoutConfig({
    this.cartEnabled = true,
    this.customerName = true,
    this.deliveryAddress = false,
    this.orderNotes = true,
    this.phone = true,
  });

  final bool cartEnabled;
  final bool customerName;
  final bool deliveryAddress;
  final bool orderNotes;
  final bool phone;

  static const ShopCheckoutConfig defaults = ShopCheckoutConfig();

  factory ShopCheckoutConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return defaults;
    return ShopCheckoutConfig(
      cartEnabled: map['cartEnabled'] != false,
      customerName: map['customerName'] != false,
      deliveryAddress: map['deliveryAddress'] == true,
      orderNotes: map['orderNotes'] != false,
      phone: map['phone'] != false,
    );
  }

  Map<String, dynamic> toMap() => {
        'cartEnabled': cartEnabled,
        'customerName': customerName,
        'deliveryAddress': deliveryAddress,
        'orderNotes': orderNotes,
        'phone': phone,
      };

  ShopCheckoutConfig copyWith({
    bool? cartEnabled,
    bool? customerName,
    bool? deliveryAddress,
    bool? orderNotes,
    bool? phone,
  }) =>
      ShopCheckoutConfig(
        cartEnabled: cartEnabled ?? this.cartEnabled,
        customerName: customerName ?? this.customerName,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        orderNotes: orderNotes ?? this.orderNotes,
        phone: phone ?? this.phone,
      );

  @override
  List<Object?> get props =>
      [cartEnabled, customerName, deliveryAddress, orderNotes, phone];
}
