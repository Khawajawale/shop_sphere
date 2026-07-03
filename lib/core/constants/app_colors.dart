import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand
  static const Color primary = Color(0xFF5B5FEF);
  static const Color secondary = Color(0xFF7A5CFA);

  // Accent
  static const Color accent = Color(0xFF00C2FF);

  // Success
  static const Color success = Color(0xFF22C55E);

  // Error
  static const Color error = Color(0xFFEF4444);

  // Background
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);

  // Glass
  static const Color glassLight =
      Color.fromRGBO(255, 255, 255, 0.72);

  static const Color glassDark =
      Color.fromRGBO(30, 41, 59, 0.72);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Gradient
  static const LinearGradient primaryGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      secondary,
    ],
  );

  static const LinearGradient backgroundGradient =
      LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFF),
      Color(0xFFEAF2FF),
    ],
  );
}