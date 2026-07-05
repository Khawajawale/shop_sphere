import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl
    implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final snapshot =
        await remoteDataSource.getFeaturedProducts();

    return snapshot.docs
        .map(
          (doc) => ProductModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<List<Product>> getAllProducts() async {
    final snapshot =
        await remoteDataSource.getAllProducts();

    return snapshot.docs
        .map(
          (doc) => ProductModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(
    String categoryId,
  ) async {
    final snapshot =
        await remoteDataSource.getProductsByCategory(
      categoryId,
    );

    return snapshot.docs
        .map(
          (doc) => ProductModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<Product> getProductById(
    String productId,
  ) async {
    final snapshot =
        await remoteDataSource.getProductById(
      productId,
    );

    if (!snapshot.exists) {
      throw Exception('Product not found');
    }

    return ProductModel.fromFirestore(
      snapshot.data()!,
      snapshot.id,
    );
  }

  @override
  Future<List<Product>> searchProducts(
    String query,
  ) async {
    final snapshot =
        await remoteDataSource.searchProducts(
      query,
    );

    return snapshot.docs
        .map(
          (doc) => ProductModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }
}