import 'package:flutter/material.dart';

import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../../core/widgets/glass_container.dart';
import 'auth_footer.dart';
import 'auth_header.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;

  final Widget child;

  final String footerText;
  final String footerActionText;
  final VoidCallback onFooterPressed;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.footerText,
    required this.footerActionText,
    required this.onFooterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isCompact = mediaQuery.size.height < 760;

    final keyboardOpen = mediaQuery.viewInsets.bottom > 0;

    Widget formCard = GlassContainer(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 24,
        vertical: isCompact ? 20 : 24,
      ),
      child: child,
    );

    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: keyboardOpen
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            reverse: true,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 12),
                            child: formCard,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: isCompact ? 8 : 16),

                        AuthHeader(
                          logoPath: 'assets/images/logo.png',
                          title: title,
                          subtitle: subtitle,
                          logoSize: 115,
                          logoBottomSpacing: isCompact ? 28 : 40,
                          titleFontSize: isCompact ? 28 : 30,
                          subtitleFontSize: isCompact ? 14 : 15,
                        ),

                        SizedBox(height: isCompact ? 20 : 32),

                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  child: formCard,
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: isCompact ? 10 : 14),

                        AuthFooter(
                          text: footerText,
                          actionText: footerActionText,
                          onPressed: onFooterPressed,
                        ),

                        SizedBox(height: isCompact ? 12 : 16),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}