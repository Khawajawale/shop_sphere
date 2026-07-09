import 'dart:convert';

import '../../../../core/storage/app_preferences.dart';
import '../models/product_model.dart';
import '../../../catalog/data/product_catalog_loader.dart';

/// Local catalog used when Firestore is empty or unavailable.
/// Loads from bundled JSON — same source as Firestore seed data.
class ProductLocalDataSource {
  static const String _managedCatalogKey = 'admin_managed_catalog_v1';
  List<ProductModel>? _products;

  Future<void> _ensureLoaded() async {
    _products ??= await _loadCatalog();
  }

  Future<List<ProductModel>> _loadCatalog() async {
    final raw = AppPreferences.instance.getString(_managedCatalogKey);
    if (raw != null && raw.isNotEmpty) {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => ProductModel.fromFirestore(
              Map<String, dynamic>.from(item as Map),
              item['id'] as String,
            ),
          )
          .toList(growable: true);
    }

    return (await ProductCatalogLoader.load()).toList(growable: true);
  }

  Future<void> _persist(List<ProductModel> products) async {
    _products = List<ProductModel>.from(products, growable: true);
    final encoded = products
        .map(
          (product) => {
            'id': product.id,
            ...product.toFirestore(),
          },
        )
        .toList(growable: false);
    await AppPreferences.instance.setString(
      _managedCatalogKey,
      json.encode(encoded),
    );
  }

  Future<bool> hasManagedCatalog() async {
    final raw = AppPreferences.instance.getString(_managedCatalogKey);
    return raw != null && raw.isNotEmpty;
  }

  Future<List<ProductModel>> getAllProducts() async {
    await _ensureLoaded();
    return List.unmodifiable(_products!);
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    await _ensureLoaded();
    return _products!
        .where((p) => p.featured)
        .toList(growable: false);
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await _ensureLoaded();
    return _products!
        .where((p) => p.categoryId == categoryId)
        .toList(growable: false);
  }

  Future<ProductModel?> getProductById(String productId) async {
    await _ensureLoaded();
    try {
      return _products!.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    await _ensureLoaded();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return [];

    return _products!
        .where(
          (p) =>
              p.name.toLowerCase().contains(normalized) ||
              p.description.toLowerCase().contains(normalized) ||
              p.categoryId.toLowerCase().contains(normalized),
        )
        .toList(growable: false);
  }

  Future<void> addProduct(ProductModel product) async {
    await _ensureLoaded();
    final products = List<ProductModel>.from(_products!, growable: true);
    products.insert(0, product);
    await _persist(products);
  }

  Future<void> updateProduct(ProductModel updatedProduct) async {
    await _ensureLoaded();
    final products = List<ProductModel>.from(_products!, growable: true);
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index == -1) return;
    products[index] = updatedProduct;
    await _persist(products);
  }

  Future<void> deleteProduct(String productId) async {
    await _ensureLoaded();
    final products = List<ProductModel>.from(_products!, growable: true)
      ..removeWhere((p) => p.id == productId);
    await _persist(products);
  }
}
