import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_shadows.dart';
import '../../constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return AnimatedContainer(
      duration: AppDurations.normal,
      width: width ?? double.infinity,
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        gradient: enabled
            ? AppColors.primaryGradient
            : LinearGradient(
                colors: [
                  Colors.grey.shade400,
                  Colors.grey.shade500,
                ],
              ),
        borderRadius: AppSizes.mediumRadius,
        boxShadow: enabled ? AppShadows.button : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSizes.mediumRadius,
          onTap: enabled ? onPressed : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}