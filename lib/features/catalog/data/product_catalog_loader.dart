import 'dart:convert';

import 'package:flutter/services.dart';

import '../../home/data/models/product_model.dart';

/// Loads the canonical product catalog from bundled JSON.
class ProductCatalogLoader {
  static const assetPath = 'assets/seed/products_catalog.json';

  static List<ProductModel>? _cache;

  static Future<List<ProductModel>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr = await rootBundle.loadString(assetPath);
    final List<dynamic> decoded = json.decode(jsonStr);

    _cache = decoded
        .map(
          (item) => ProductModel(
            id: item['id'] as String,
            name: item['name'] as String,
            description: item['description'] as String,
            price: (item['price'] as num).toDouble(),
            salePrice: item['salePrice'] != null
                ? (item['salePrice'] as num).toDouble()
                : null,
            images: List<String>.from(item['images'] as List),
            categoryId: item['categoryId'] as String,
            inStock: item['inStock'] as bool? ?? true,
            stockQuantity: item['stockQuantity'] as int? ?? 0,
            rating: (item['rating'] as num?)?.toDouble() ?? 0,
            reviewCount: item['reviewCount'] as int? ?? 0,
            featured: item['featured'] as bool? ?? false,
            createdAt: DateTime.parse(item['createdAt'] as String),
          ),
        )
        .toList(growable: false);

    return _cache!;
  }

  /// Clears the in-memory cache (useful after hot reload during development).
  static void clearCache() => _cache = null;
}
