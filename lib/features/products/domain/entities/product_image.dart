import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  const ProductImage({required this.url, this.active = true});

  final String url;
  final bool active;

  ProductImage copyWith({String? url, bool? active}) => ProductImage(
        url: url ?? this.url,
        active: active ?? this.active,
      );

  static List<ProductImage> fromFirestoreList(dynamic raw) {
    if (raw is! List) return const [];
    final out = <ProductImage>[];
    for (final item in raw) {
      if (item is Map) {
        final url = (item['url'] ?? '').toString().trim();
        if (url.isEmpty) continue;
        out.add(ProductImage(url: url, active: item['active'] != false));
      } else if (item is String && item.trim().isNotEmpty) {
        out.add(ProductImage(url: item.trim(), active: true));
      }
    }
    return out;
  }

  static List<ProductImage> fromUrlList(List<String> urls) =>
      urls.map((u) => ProductImage(url: u, active: true)).toList();

  Map<String, dynamic> toMap() => {'url': url, 'active': active};

  @override
  List<Object?> get props => [url, active];
}
