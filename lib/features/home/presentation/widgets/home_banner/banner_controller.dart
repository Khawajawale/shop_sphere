import 'dart:async';

import 'package:flutter/material.dart';

class BannerController {
  BannerController({
    required this.pageController,
    required this.bannerCount,
  });

  final PageController pageController;

  final int bannerCount;

  Timer? _timer;

  int currentPage = 0;

  void start(VoidCallback refresh) {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        currentPage++;

        if (currentPage >= bannerCount) {
          currentPage = 0;
        }

        pageController.animateToPage(
          currentPage,
          duration:
              const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
        );

        refresh();
      },
    );
  }

  void stop() {
    _timer?.cancel();
  }
}