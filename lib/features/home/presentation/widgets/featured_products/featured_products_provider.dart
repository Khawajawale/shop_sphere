import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/product_state.dart';
import '../../providers/product_provider.dart';
import '../../providers/selected_category_provider.dart';
import '../../../domain/entities/product.dart';
import '../category_section/category_data.dart';

final featuredProductsViewStateProvider =
    Provider<FeaturedProductsViewState>((ref) {
  final productState = ref.watch(productControllerProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  final filteredProducts = _filterFeaturedProducts(
    products: productState.featuredProducts,
    selectedCategory: selectedCategory,
  );

  return FeaturedProductsViewState(
    products: filteredProducts,
    selectedCategory: selectedCategory,
    selectedCategoryTitle: _resolveCategoryTitle(
      selectedCategory,
    ),
    productState: productState,
  );
});

List<Product> _filterFeaturedProducts({
  required List<Product> products,
  required String? selectedCategory,
}) {
  if (selectedCategory == null) {
    return products;
  }

  return products
      .where(
        (product) => product.categoryId == selectedCategory,
      )
      .toList(growable: false);
}

String? _resolveCategoryTitle(String? categoryId) {
  if (categoryId == null) {
    return null;
  }

  for (final category in CategoryData.categories) {
    if (category.id == categoryId) {
      return category.title;
    }
  }

  return null;
}

class FeaturedProductsViewState {
  final List<Product> products;
  final String? selectedCategory;
  final String? selectedCategoryTitle;
  final ProductState productState;

  const FeaturedProductsViewState({
    required this.products,
    required this.selectedCategory,
    required this.selectedCategoryTitle,
    required this.productState,
  });

  bool get isLoading =>
      productState.isLoading &&
      productState.featuredProducts.isEmpty;

  bool get hasError =>
      productState.errorMessage != null &&
      productState.featuredProducts.isEmpty;

  String get subtitle {
    if (selectedCategoryTitle != null) {
      return 'Top picks in $selectedCategoryTitle';
    }

    return 'Hand-picked products for you';
  }
}
