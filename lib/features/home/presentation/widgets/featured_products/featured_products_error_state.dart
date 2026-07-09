import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'featured_products_constants.dart';

class FeaturedProductsErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const FeaturedProductsErrorState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Failed to load featured products',
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal:
              FeaturedProductsConstants.horizontalPadding,
        ),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFB),
          borderRadius: AppSizes.cardRadius,
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSizes.sm),
            const Expanded(
              child: Text(
                'Unable to load featured products right now.',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: AppSizes.sm),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
