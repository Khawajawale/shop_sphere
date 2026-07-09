import 'package:flutter/material.dart';

import 'category_model.dart';

class CategoryData {
  CategoryData._();

  static const String _assetPath =
      'assets/images/categories';

  static final List<CategoryModel> categories = [
    CategoryModel(
      id: 'electronics',
      title: 'Electronics',
      imageAsset: '$_assetPath/electronics.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFF3B82F6),
      priority: 1,
      deepLink: 'shop://category/electronics',
    ),

    CategoryModel(
      id: 'fashion',
      title: 'Fashion',
      imageAsset: '$_assetPath/fashion.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFFEC4899),
      priority: 2,
      deepLink: 'shop://category/fashion',
    ),

    CategoryModel(
      id: 'home',
      title: 'Home',
      imageAsset: '$_assetPath/home.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFF78716C),
      priority: 3,
      deepLink: 'shop://category/home',
    ),

    CategoryModel(
      id: 'beauty',
      title: 'Beauty',
      imageAsset: '$_assetPath/beauty.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFFA855F7),
      priority: 4,
      deepLink: 'shop://category/beauty',
    ),

    CategoryModel(
      id: 'sports',
      title: 'Sports',
      imageAsset: '$_assetPath/sports.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFF10B981),
      priority: 5,
      deepLink: 'shop://category/sports',
    ),

    CategoryModel(
      id: 'toys',
      title: 'Toys',
      imageAsset: '$_assetPath/toys.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFF6366F1),
      priority: 6,
      deepLink: 'shop://category/toys',
    ),

    CategoryModel(
      id: 'more',
      title: 'More',
      imageAsset: '$_assetPath/more.png',
      backgroundColor: Colors.white,
      iconColor: const Color(0xFF6B7280),
      priority: 7,
      deepLink: 'shop://categories',
    ),
  ];
}
