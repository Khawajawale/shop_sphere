import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/animated_section.dart';
import 'category_card.dart';
import 'category_constants.dart';
import 'category_data.dart';

class CategoryList extends StatelessWidget {
  final String? selectedCategoryId;

  final ValueChanged<String>? onCategorySelected;

  const CategoryList({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CategoryData.categories;

    return SizedBox(
      height: 138,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          0,
          AppSizes.md,
          AppSizes.md,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(
          width: CategoryConstants.itemSpacing,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return AnimatedSection(
            delay: CategoryConstants.staggerDelay * index,
            duration: const Duration(milliseconds: 450),
            offset: 20,
            child: CategoryCard(
              category: category,
              selected: selectedCategoryId == category.id,
              onTap: () {
                onCategorySelected?.call(category.id);
              },
            ),
          );
        },
      ),
    );
  }
}
