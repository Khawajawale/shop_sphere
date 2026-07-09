import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'featured_products_constants.dart';

class FeaturedProductsEmptyState extends StatelessWidget {
  final String? categoryTitle;

  const FeaturedProductsEmptyState({
    super.key,
    this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = categoryTitle == null
        ? 'No featured products available yet. Check back soon.'
        : 'No featured items in $categoryTitle right now.';

    return Semantics(
      label: 'No featured products to display',
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal:
              FeaturedProductsConstants.horizontalPadding,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSizes.cardRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            const Text(
              'Nothing to show',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
