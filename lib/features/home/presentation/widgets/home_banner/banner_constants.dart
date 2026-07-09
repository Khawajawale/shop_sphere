import 'package:flutter/material.dart';

class BannerConstants {
  BannerConstants._();

  static const Duration autoSlideDuration =
      Duration(seconds: 4);

  static const Duration animationDuration =
      Duration(milliseconds: 450);

  static const Curve animationCurve =
      Curves.easeInOutCubic;

  static const double minHeight = 185;

  static const double maxHeight = 240;

  static const double horizontalPadding = 16;
}