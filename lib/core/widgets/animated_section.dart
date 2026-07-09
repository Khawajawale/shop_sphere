import 'package:flutter/material.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation duration.
  final Duration duration;

  /// Vertical offset before appearing.
  final double offset;

  const AnimatedSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 24,
  });

  @override
  State<AnimatedSection> createState() =>
      _AnimatedSectionState();
}

class _AnimatedSectionState
    extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacity;

  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: Offset(
        0,
        widget.offset / 100,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}