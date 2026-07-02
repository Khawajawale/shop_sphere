import 'package:flutter/material.dart';

class OnboardingController {
  final PageController pageController = PageController();

  void dispose() {
    pageController.dispose();
  }
}