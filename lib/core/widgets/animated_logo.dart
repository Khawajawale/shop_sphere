import 'package:flutter/material.dart';

import '../animations/floating_animation.dart';
import '../constants/app_colors.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final String assetPath;

  const AnimatedLogo({
    super.key,
    required this.assetPath,
    this.size = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'shopsphere-logo',
      child: FloatingAnimation(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 35,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(18),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}