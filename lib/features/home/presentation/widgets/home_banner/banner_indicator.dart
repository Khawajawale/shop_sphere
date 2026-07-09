import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class BannerIndicator extends StatelessWidget {
  final int currentIndex;

  final int itemCount;

  const BannerIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          final selected =
              index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            height: 8,
            width: selected ? 28 : 8,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : Colors.grey.shade300,
              borderRadius:
                  BorderRadius.circular(100),
            ),
          );
        },
      ),
    );
  }
}