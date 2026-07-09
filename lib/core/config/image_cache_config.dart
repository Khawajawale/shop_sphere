import 'package:flutter/material.dart';

/// Global image cache tuning for smoother scrolling and lower memory use.
class ImageCacheConfig {
  ImageCacheConfig._();

  static void configure() {
    PaintingBinding.instance.imageCache.maximumSize = 200;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 80 << 20; // 80 MB
  }
}
