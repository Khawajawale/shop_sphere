import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/performance_service.dart';
import '../../../../core/security/safe_error_message.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductController
    extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductController(
    this.repository,
  ) : super(const ProductState());

  Future<void> loadHomeProducts() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await PerformanceService.traceVoid(
        'load_home_products',
        () async {
          final featured = await repository.getFeaturedProducts();
          final products = await repository.getAllProducts();

          state = state.copyWith(
            isLoading: false,
            featuredProducts: featured,
            allProducts: products,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: SafeErrorMessage.generic,
      );
    }
  }
}