import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shadows.dart';

class WishlistButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;

  const WishlistButton({
    super.key,
    required this.isFavorite,
    this.onPressed,
  });

  @override
  State<WishlistButton> createState() =>
      _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.90 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.88),
          boxShadow: _pressed
              ? AppShadows.small
              : AppShadows.medium,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onPressed,
            onTapDown: (_) {
              setState(() {
                _pressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _pressed = false;
              });
            },
            onTapCancel: () {
              setState(() {
                _pressed = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 220,
                ),
                transitionBuilder:
                    (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  widget.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  key: ValueKey(widget.isFavorite),
                  color: widget.isFavorite
                      ? AppColors.favorite
                      : Colors.grey.shade700,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}