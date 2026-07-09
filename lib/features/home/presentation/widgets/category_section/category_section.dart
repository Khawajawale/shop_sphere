import 'package:flutter/material.dart';

import '../../../../../core/constants/app_shadows.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'category_constants.dart';
import 'category_list.dart';

class CategorySection extends StatefulWidget {
  final String? selectedCategoryId;

  final ValueChanged<String?>? onCategorySelected;

  final VoidCallback? onSeeAll;

  const CategorySection({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.onSeeAll,
  });

  @override
  State<CategorySection> createState() =>
      _CategorySectionState();
}

class _CategorySectionState
    extends State<CategorySection> {
  String? _selectedCategoryId;

  String? get _currentSelection =>
      widget.selectedCategoryId ??
      _selectedCategoryId;

  void _selectCategory(String id) {
    final nextSelection =
        _currentSelection == id ? null : id;

    if (widget.onCategorySelected != null) {
      widget.onCategorySelected!(nextSelection);
    } else {
      setState(() {
        _selectedCategoryId = nextSelection;
      });
    }
  }

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
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.lg,
                AppSizes.sm,
                AppSizes.sm,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Shop by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onSeeAll,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          CategoryConstants.selectionColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            CategoryList(
              selectedCategoryId: _currentSelection,
              onCategorySelected: _selectCategory,
            ),
          ],
        ),
      ),
    );
  }
}
