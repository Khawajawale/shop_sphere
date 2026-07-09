import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/accessibility_labels.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../home/presentation/widgets/product_card/product_card.dart';
import '../providers/wishlist_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Your Favorites',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: favorites.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.50,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return AnimatedSection(
                    delay: Duration(milliseconds: 50 * index),
                    child: ProductCard(
                      product: product,
                      compact: true,
                      isFavorite: true,
                      onTap: () {
                        context.push('/product/${product.id}');
                      },
                      onWishlist: () {
                        ref
                            .read(wishlistControllerProvider.notifier)
                            .toggleFavorite(product.id);
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
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Semantics(
      label: AccessibilityLabels.emptyWishlist,
      child: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            const Text(
              'Tap the heart icon on any product to save it here for later retrieval.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
