import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../providers/selected_category_provider.dart';
import '../category_section/category_constants.dart';
import '../category_section/category_data.dart';
import 'featured_products_constants.dart';

class FeaturedProductsFilter extends ConsumerWidget {
  const FeaturedProductsFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = CategoryData.categories
        .where((category) => category.id != 'more')
        .toList();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal:
              FeaturedProductsConstants.horizontalPadding,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _FilterChip(
              label: 'All',
              selected: selectedCategory == null,
              onTap: () {
                ref
                    .read(selectedCategoryProvider.notifier)
                    .state = null;
              },
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategory == category.id;

          return _FilterChip(
            label: category.title,
            selected: isSelected,
            onTap: () {
              ref
                  .read(selectedCategoryProvider.notifier)
                  .state = isSelected ? null : category.id;
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label filter',
      child: Material(
        color: selected
            ? CategoryConstants.selectionColor
            : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? CategoryConstants.selectionColor
                    : AppColors.border,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
