import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class DiscountBadge extends StatelessWidget {
  final int percentage;

  const DiscountBadge({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    if (percentage <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.discount,
        borderRadius: AppSizes.mediumRadius,
      ),
      child: Text(
        '-$percentage%',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}