import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final double offset;
  final Duration duration;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.offset = 12,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (_, child) {
        final dy =
            math.sin(_controller.value * 2 * math.pi) *
                widget.offset;

        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
    );
  }
}