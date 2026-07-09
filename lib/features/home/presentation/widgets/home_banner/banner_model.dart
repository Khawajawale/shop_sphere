import 'package:flutter/material.dart';

class BannerModel {
  final String id;

  final String title;

  final String subtitle;

  final String buttonText;

  final String image;

  final List<Color> gradient;

  final VoidCallback? onTap;

  // =========================================================
  // Future Firestore Campaign Fields
  // =========================================================

  final bool isActive;

  final int priority;

  final DateTime? startDate;

  final DateTime? endDate;

  /// Example:
  ///
  /// shop://category/electronics
  ///
  /// shop://product/iphone16
  ///
  /// shop://sale/summer2026
  final String? deepLink;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.image,
    required this.gradient,
    this.onTap,

    this.isActive = true,
    this.priority = 0,
    this.startDate,
    this.endDate,
    this.deepLink,
  });

  bool get isVisible {
    if (!isActive) return false;

    final now = DateTime.now();

    if (startDate != null &&
        now.isBefore(startDate!)) {
      return false;
    }

    if (endDate != null &&
        now.isAfter(endDate!)) {
      return false;
    }

    return true;
  }
}