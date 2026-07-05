class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final List<String> images;
  final String categoryId;
  final bool inStock;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final bool featured;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.images,
    required this.categoryId,
    required this.inStock,
    required this.stockQuantity,
    required this.rating,
    required this.reviewCount,
    required this.featured,
    required this.createdAt,
  });

  bool get hasDiscount =>
      salePrice != null && salePrice! < price;

  double get currentPrice =>
      salePrice ?? price;

  int get discountPercentage {
    if (!hasDiscount) return 0;

    return (((price - salePrice!) / price) * 100).round();
  }
}