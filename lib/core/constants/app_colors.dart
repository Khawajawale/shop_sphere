import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================================================
  // BRAND
  // =========================================================

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFFF59E0B);

  // Compatibility
  static const Color accent = secondary;

  // =========================================================
  // GRADIENTS
  // =========================================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =========================================================
  // BACKGROUND
  // =========================================================

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;

  // =========================================================
  // TEXT
  // =========================================================

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // =========================================================
  // STATUS
  // =========================================================

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // =========================================================
  // PRODUCT
  // =========================================================

  static const Color discount = Color(0xFFDC2626);
  static const Color rating = Color(0xFFFFB800);
  static const Color favorite = Color(0xFFE11D48);

  // =========================================================
  // BORDER
  // =========================================================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF1F5F9);

  // =========================================================
  // INPUT
  // =========================================================

  static const Color inputFill = Color(0xFFF8FAFC);
  static const Color hint = Color(0xFF9CA3AF);

  // =========================================================
  // GLASS
  // =========================================================

  static const Color glassLight = Color.fromARGB(90, 255, 255, 255);

  static const Color glassDark = Color.fromARGB(40, 255, 255, 255);

  // =========================================================
  // SHADOW
  // =========================================================

  static const Color shadow = Color(0x14000000);
}