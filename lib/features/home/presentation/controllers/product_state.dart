import '../../domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> featuredProducts;
  final List<Product> allProducts;
  final String? errorMessage;

  const ProductState({
    this.isLoading = false,
    this.featuredProducts = const [],
    this.allProducts = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? featuredProducts,
    List<Product>? allProducts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      featuredProducts:
          featuredProducts ?? this.featuredProducts,
      allProducts: allProducts ?? this.allProducts,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}