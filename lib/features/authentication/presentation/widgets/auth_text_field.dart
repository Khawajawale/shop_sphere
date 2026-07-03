import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.primary,
        ),

        filled: true,

        fillColor: isDark
            ? Colors.white.withValues(alpha: .06)
            : Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}