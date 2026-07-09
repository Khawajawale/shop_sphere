import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/product_local_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_state.dart';

final productLocalDataSourceProvider =
    Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSource();
});

final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    ref.read(productRemoteDataSourceProvider),
    ref.read(productLocalDataSourceProvider),
  );
});

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductState>((ref) {
  return ProductController(
    ref.read(productRepositoryProvider),
  );
});

final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  try {
    return await ref.read(productRepositoryProvider).getProductById(productId);
  } catch (_) {
    return null;
  }
});

final searchProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  return ref.read(productRepositoryProvider).searchProducts(query);
});
