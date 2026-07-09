import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/animated_section.dart';
import '../../../../cart/presentation/providers/cart_provider.dart';
import '../../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../providers/product_provider.dart';
import '../product_card/product_card.dart';
import 'featured_products_constants.dart';
import 'featured_products_empty_state.dart';
import 'featured_products_error_state.dart';
import 'featured_products_provider.dart';
import 'featured_products_shimmer.dart';

class FeaturedProductsList extends ConsumerWidget {
  const FeaturedProductsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(
      featuredProductsViewStateProvider,
    );
    final products = viewState.products;
    final wishlist = ref.watch(wishlistControllerProvider);

    if (viewState.isLoading) {
      return const FeaturedProductsShimmer();
    }

    if (viewState.hasError) {
      return FeaturedProductsErrorState(
        onRetry: () {
          ref
              .read(productControllerProvider.notifier)
              .loadHomeProducts();
        },
      );
    }

    if (products.isEmpty) {
      return FeaturedProductsEmptyState(
        categoryTitle: viewState.selectedCategoryTitle,
      );
    }

    return Semantics(
      label: 'Featured products list',
      child: SizedBox(
        height: FeaturedProductsConstants.listHeight,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal:
                FeaturedProductsConstants.horizontalPadding,
          ),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: 18),
          itemBuilder: (context, index) {
            final product = products[index];
            final isFavorite = wishlist.contains(product.id);

            return AnimatedSection(
              delay: FeaturedProductsConstants.staggerDelay *
                  index,
              duration: const Duration(milliseconds: 450),
              offset: 20,
              child: SizedBox(
                width: FeaturedProductsConstants.cardWidth,
                child: ProductCard(
                  product: product,
                  isFavorite: isFavorite,
                  onTap: () {
                    context.push('/product/${product.id}');
                  },
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
              ),
            );
          },
        ),
      ),
    );
  }
}
