import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.salePrice,
    required super.images,
    required super.categoryId,
    required super.inStock,
    required super.stockQuantity,
    required super.rating,
    required super.reviewCount,
    required super.featured,
    required super.createdAt,
  });

  factory ProductModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      salePrice: data['salePrice'] != null
          ? (data['salePrice']).toDouble()
          : null,
      images: List<String>.from(data['images'] ?? []),
      categoryId: data['categoryId'] ?? '',
      inStock: data['inStock'] ?? true,
      stockQuantity: data['stockQuantity'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      featured: data['featured'] ?? false,
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'images': images,
      'categoryId': categoryId,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'featured': featured,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}