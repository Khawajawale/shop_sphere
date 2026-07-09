import '../../data/datasources/product_local_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(
    this.remoteDataSource, [
    ProductLocalDataSource? localDataSource,
  ]) : localDataSource = localDataSource ?? ProductLocalDataSource();

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      return await localDataSource.getFeaturedProducts();
    } catch (_) {
      // Fall through to remote data source
    }
    try {
      final snapshot = await remoteDataSource.getFeaturedProducts();
      if (snapshot.docs.isNotEmpty) return _mapSnapshot(snapshot);
    } catch (_) {
      // Ignore remote failures in demo mode
    }
    return const <Product>[];
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      return await localDataSource.getAllProducts();
    } catch (_) {
      // Fall through to remote data source
    }
    try {
      final snapshot = await remoteDataSource.getAllProducts();
      if (snapshot.docs.isNotEmpty) return _mapSnapshot(snapshot);
    } catch (_) {
      // Ignore remote failures in demo mode
    }
    return const <Product>[];
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      return await localDataSource.getProductsByCategory(categoryId);
    } catch (_) {
      // Fall through to remote data source
    }
    try {
      final snapshot =
          await remoteDataSource.getProductsByCategory(categoryId);
      if (snapshot.docs.isNotEmpty) return _mapSnapshot(snapshot);
    } catch (_) {
      // Ignore remote failures in demo mode
    }
    return const <Product>[];
  }

  @override
  Future<Product> getProductById(String productId) async {
    try {
      final local = await localDataSource.getProductById(productId);
      if (local != null) return local;
    } catch (_) {
      // Fall through to remote data source
    }
    try {
      final snapshot = await remoteDataSource.getProductById(productId);
      if (snapshot.exists) {
        return ProductModel.fromFirestore(snapshot.data()!, snapshot.id);
      }
    } catch (_) {
      // Ignore remote failures in demo mode
    }

    throw Exception('Product not found');
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      return await localDataSource.searchProducts(query);
    } catch (_) {
      // Fall through to remote data source
    }
    try {
      final snapshot = await remoteDataSource.searchProducts(query);
      if (snapshot.docs.isNotEmpty) return _mapSnapshot(snapshot);
    } catch (_) {
      // Ignore remote failures in demo mode
    }
    return const <Product>[];
  }

  List<Product> _mapSnapshot(
    dynamic snapshot,
  ) {
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
