import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // =========================================================
  // SPACING
  // =========================================================

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // =========================================================
  // BACKWARD COMPATIBILITY
  // (Keeps old widgets working)
  // =========================================================

  static const double spacingXS = xs;
  static const double spacingS = sm;
  static const double spacingM = md;
  static const double spacingL = lg;
  static const double spacingXL = xl;
  static const double spacingXXL = xxl;

  // =========================================================
  // BORDER RADIUS
  // =========================================================

  static const BorderRadius smallRadius =
      BorderRadius.all(Radius.circular(8));

  static const BorderRadius mediumRadius =
      BorderRadius.all(Radius.circular(12));

  static const BorderRadius largeRadius =
      BorderRadius.all(Radius.circular(20));

  static const BorderRadius cardRadius =
      BorderRadius.all(Radius.circular(18));

  // Old name used throughout Authentication module
  static const double radius = 12;

  // =========================================================
  // COMPONENT SIZES
  // =========================================================

  static const double buttonHeight = 56;

  static const double productImageHeight = 145;

  static const double bannerHeight = 180;

  static const double searchHeight = 54;

  static const double categorySize = 60;

  static const double productCardWidth = 180;

  static const double avatar = 42;
}