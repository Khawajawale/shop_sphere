import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/animated_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoPath;
  final double logoSize;
  final double titleFontSize;
  final double subtitleFontSize;
  final double logoBottomSpacing;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoPath,
    this.logoSize = 115,
    this.titleFontSize = 30,
    this.subtitleFontSize = 15,
    this.logoBottomSpacing = AppSizes.spacingXL,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (showLogo) ...[
          AnimatedLogo(
            assetPath: logoPath,
            size: logoSize,
          ),
          SizedBox(height: logoBottomSpacing),
        ],

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
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
              fontSize: subtitleFontSize,
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