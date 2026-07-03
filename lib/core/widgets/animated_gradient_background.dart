import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final value = _controller.value;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1 + value,
                -1,
              ),
              end: Alignment(
                1 - value,
                1,
              ),
              colors: isDark
                  ? const [
                      Color(0xFF0F172A),
                      Color(0xFF1E293B),
                      Color(0xFF312E81),
                    ]
                  : const [
                      Color(0xFFF8FAFF),
                      Color(0xFFE8EEFF),
                      Color(0xFFDDE8FF),
                    ],
            ),
          ),
          child: Stack(
            children: [

              Positioned(
                top: -100,
                left: -60,
                child: _buildBlob(
                  size: 240,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),

              Positioned(
                bottom: -120,
                right: -80,
                child: _buildBlob(
                  size: 300,
                  color: AppColors.secondary.withValues(alpha: 0.15),
                ),
              ),

              Positioned(
                top: 250,
                right: -40,
                child: _buildBlob(
                  size: 170,
                  color: AppColors.accent.withValues(alpha: 0.12),
                ),
              ),

              widget.child,
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlob({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}