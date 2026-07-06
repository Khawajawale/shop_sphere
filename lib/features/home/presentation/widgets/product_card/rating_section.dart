import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class RatingSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingSection({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //--------------------------------------------------
        // Star Badge
        //--------------------------------------------------

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: AppColors.rating.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.star_rounded,
            color: AppColors.rating,
            size: 16,
          ),
        ),

        const SizedBox(width: AppSizes.sm),

        //--------------------------------------------------
        // Rating
        //--------------------------------------------------

        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(width: AppSizes.xs),

        //--------------------------------------------------
        // Reviews
        //--------------------------------------------------

        Flexible(
          child: Text(
            '($reviewCount reviews)',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}