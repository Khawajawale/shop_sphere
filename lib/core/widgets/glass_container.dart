import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius:
          borderRadius ?? BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.glassDark
                : AppColors.glassLight,
            borderRadius:
                borderRadius ??
                    BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
            ),
            boxShadow: AppShadows.glass,
          ),
          child: child,
        ),
      ),
    );
  }
}