import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import 'product_card/product_card.dart';
import 'featured_products/featured_products_constants.dart';

class ProductHorizontalList extends ConsumerWidget {
  final String title;
  final String subtitle;
  final List<dynamic> products;
  final VoidCallback? onSeeAll;

  const ProductHorizontalList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.products,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final wishlist = ref.watch(wishlistControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // LIST VIEW
          SizedBox(
            height: FeaturedProductsConstants.listHeight,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFavorite = wishlist.contains(product.id);

                return AnimatedSection(
                  delay: Duration(milliseconds: 60 * index),
                  duration: const Duration(milliseconds: 400),
                  offset: 15,
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
        ],
      ),
    );
  }
}
