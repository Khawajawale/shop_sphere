import 'package:flutter/material.dart';

class CategoryModel {
  final String id;

  final String title;

  final String? imageAsset;

  final IconData? icon;

  final Color backgroundColor;

  final Color iconColor;

  final int priority;

  final String? deepLink;

  const CategoryModel({
    required this.id,
    required this.title,
    this.imageAsset,
    this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.priority,
    this.deepLink,
  }) : assert(
         imageAsset != null || icon != null,
         'Category must have an imageAsset or icon',
       );
}
