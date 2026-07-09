import 'package:flutter/material.dart';

import '../../constants/accessibility_labels.dart';
import '../../constants/app_borders.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_shadows.dart';
import '../../constants/app_sizes.dart';
import 'search_filter_button.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final VoidCallback? onFilterPressed;

  final bool readOnly;

  final String hintText;

  final Widget? suffix;

  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onFilterPressed,
    this.readOnly = false,
    this.hintText = 'Search products...',
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_search_bar',
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSizes.mediumRadius,
              boxShadow: AppShadows.small,
            ),
            child: Semantics(
              textField: true,
              label: AccessibilityLabels.searchProducts,
              child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              readOnly: readOnly,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,

                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                ),

                suffixIcon: suffix ??
                    SearchFilterButton(
                      onPressed: onFilterPressed,
                    ),

                filled: true,
                fillColor: AppColors.surface,

                enabledBorder: AppBorders.inputBorder,
                focusedBorder: AppBorders.focusedBorder,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}