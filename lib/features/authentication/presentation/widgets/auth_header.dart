import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/animated_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoPath;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AnimatedLogo(
          assetPath: logoPath,
          size: 115,
        ),

        const SizedBox(height: AppSizes.spacingXL),

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: isDark
                ? Colors.white
                : AppColors.textPrimary,
            height: 1.15,
          ),
        ),

        const SizedBox(height: AppSizes.spacingS),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 320,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? Colors.white70
                  : AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}