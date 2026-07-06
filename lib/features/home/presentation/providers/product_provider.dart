import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_state.dart';

/// Remote Data Source
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource();
});

/// Repository
final productRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    ref.read(productRemoteDataSourceProvider),
  );
});

/// Controller
final productControllerProvider =
    StateNotifierProvider<
        ProductController,
        ProductState>((ref) {
  return ProductController(
    ref.read(productRepositoryProvider),
  );
});