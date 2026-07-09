import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class SearchFilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SearchFilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Filters',
      onPressed: onPressed,
      icon: const Icon(
        Icons.tune_rounded,
        color: AppColors.primary,
      ),
    );
  }
}