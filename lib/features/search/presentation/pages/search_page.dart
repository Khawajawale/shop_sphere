import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/security/input_validators.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/search/app_search_bar.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../home/presentation/widgets/product_card/product_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProductsProvider(_query));
    final wishlist = ref.watch(wishlistControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          AppSearchBar(
            controller: _controller,
            onChanged: (value) {
              final clamped = InputValidators.clampSearchQuery(value);
              if (clamped != value) {
                _controller.value = TextEditingValue(
                  text: clamped,
                  selection: TextSelection.collapsed(offset: clamped.length),
                );
              }
              setState(() => _query = clamped);
              if (clamped.trim().length >= 2) {
                AnalyticsService.logSearch(searchTerm: clamped.trim());
              }
            },
            readOnly: false,
            hintText: 'Search products, brands, categories...',
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? _buildSuggestions()
                : searchAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    error: (_, _) => const Center(
                      child: Text(
                        'Unable to search right now. Please try again.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    data: (products) => _buildResults(products, wishlist),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              'Discover Premium Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              'Search by product name, category, or keyword.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(List<Product> products, List<String> wishlist) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found for your search.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.50,
        crossAxisSpacing: AppSizes.md,
        mainAxisSpacing: AppSizes.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return AnimatedSection(
          delay: Duration(milliseconds: 40 * index),
          child: ProductCard(
            product: product,
            compact: true,
            isFavorite: wishlist.contains(product.id),
            onTap: () => context.push('/product/${product.id}'),
            onAddToCart: () {
              ref.read(cartControllerProvider.notifier).addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            onWishlist: () {
              ref
                  .read(wishlistControllerProvider.notifier)
                  .toggleFavorite(product.id);
            },
          ),
        );
      },
    );
  }
}
