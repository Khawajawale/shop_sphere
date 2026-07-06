import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class PriceSection extends StatelessWidget {
  final double price;
  final double currentPrice;
  final bool hasDiscount;

  const PriceSection({
    super.key,
    required this.price,
    required this.currentPrice,
    required this.hasDiscount,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasDiscount) {
      return Text(
        '\$${price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: -0.3,
        ),
      );
    }

    final discount =
        (((price - currentPrice) / price) * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // Selling Price
        //--------------------------------------------------

        Text(
          '\$${currentPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 6),

        //--------------------------------------------------
        // Original Price + Save Badge
        //--------------------------------------------------

        Row(
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2,
              ),
            ),

            const SizedBox(width: AppSizes.sm),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: AppColors.discount.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: Text(
                'SAVE $discount%',
                style: const TextStyle(
                  color: AppColors.discount,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}