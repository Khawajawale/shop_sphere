import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> small = [
    const BoxShadow(
      color: AppColors.shadow,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    const BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static List<BoxShadow> large = [
    const BoxShadow(
      color: AppColors.shadow,
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];

  // Compatibility for existing widgets

  static List<BoxShadow> button = medium;

  static List<BoxShadow> glass = [
    const BoxShadow(
      color: AppColors.shadow,
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}