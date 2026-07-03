import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_sizes.dart';

class PrimaryAuthButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<PrimaryAuthButton> createState() => _PrimaryAuthButtonState();
}

class _PrimaryAuthButtonState extends State<PrimaryAuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: enabled
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapUp: enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: Container(
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            gradient: enabled
                ? AppColors.primaryGradient
                : const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.grey,
                    ],
                  ),
            borderRadius:
                BorderRadius.circular(AppSizes.radius),
            boxShadow: enabled ? AppShadows.button : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(AppSizes.radius),
              onTap: widget.onPressed,
              child: Center(
                child: AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 250),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.6,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}