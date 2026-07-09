import 'package:flutter/material.dart';

import '../../../../../core/constants/app_shadows.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'featured_product_title.dart';
import 'featured_products_filter.dart';
import 'featured_products_list.dart';

class FeaturedProductsSection extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const FeaturedProductsSection({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedProductTitle(
              onSeeAll: onSeeAll,
            ),
            const FeaturedProductsFilter(),
            const SizedBox(height: AppSizes.md),
            const FeaturedProductsList(),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
