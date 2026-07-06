import '../entities/product.dart';

abstract class ProductRepository {
  /// Returns featured products shown on the home screen.
  Future<List<Product>> getFeaturedProducts();

  /// Returns all products.
  Future<List<Product>> getAllProducts();

  /// Returns products for a specific category.
  Future<List<Product>> getProductsByCategory(
    String categoryId,
  );

  /// Returns a single product.
  Future<Product> getProductById(
    String productId,
  );

  /// Search products.
  Future<List<Product>> searchProducts(
    String query,
  );
}