import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

class AppBorders {
  AppBorders._();

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: AppSizes.mediumRadius,
    borderSide: const BorderSide(
      color: AppColors.border,
    ),
  );

  static OutlineInputBorder focusedBorder =
      OutlineInputBorder(
    borderRadius: AppSizes.mediumRadius,
    borderSide: const BorderSide(
      color: AppColors.primary,
      width: 2,
    ),
  );

  static OutlineInputBorder errorBorder =
      OutlineInputBorder(
    borderRadius: AppSizes.mediumRadius,
    borderSide: const BorderSide(
      color: AppColors.error,
    ),
  );
}