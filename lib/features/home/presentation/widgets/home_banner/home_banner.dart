import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import 'banner_card.dart';
import 'banner_indicator.dart';
import 'banner_model.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() =>
      _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _pageController;

  Timer? _timer;

  int _currentPage = 0;

  late final List<BannerModel> banners;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.94,
    );

    banners = [
      BannerModel(
        id: 'summer_sale',
        title: 'Summer\nMega Sale',
        subtitle: 'Up to 60% OFF',
        buttonText: 'Shop Now',
        image:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        gradient: const [
          Color(0xff7F00FF),
          Color(0xffE100FF),
        ],
        deepLink: 'shop://sale/summer2026',
      ),
      BannerModel(
        id: 'electronics',
        title: 'Latest\nElectronics',
        subtitle: 'Discover new arrivals',
        buttonText: 'Explore',
        image:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
        gradient: const [
          Color(0xff2563EB),
          Color(0xff06B6D4),
        ],
        deepLink: 'shop://category/electronics',
      ),
      BannerModel(
        id: 'fashion',
        title: 'Fashion\nCollection',
        subtitle: 'Trending styles today',
        buttonText: 'Browse',
        image:
            'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500',
        gradient: const [
          Color(0xffF97316),
          Color(0xffEF4444),
        ],
        deepLink: 'shop://category/fashion',
      ),
    ];

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!_pageController.hasClients) return;

        _currentPage++;

        if (_currentPage >= banners.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return BannerCard(
                banner: banners[index],
              );
            },
          ),
        ),

        const SizedBox(
          height: AppSizes.md,
        ),

        BannerIndicator(
          currentIndex: _currentPage,
          itemCount: banners.length,
        ),
      ],
    );
  }
}