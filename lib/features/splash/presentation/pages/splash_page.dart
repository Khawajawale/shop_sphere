import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/session/session_status.dart';
import '../../../../routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SessionManager _sessionManager =
      const SessionManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    final result =
        await _sessionManager.checkSession();

    if (!mounted) return;

    switch (result.status) {
      case SessionStatus.onboardingRequired:
        context.go(RouteNames.onboarding);
        break;

      case SessionStatus.unauthenticated:
        context.go(RouteNames.login);
        break;

      case SessionStatus.emailNotVerified:
        context.go(RouteNames.login);
        break;

      case SessionStatus.authenticated:
        context.go(RouteNames.home);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 100,
              height: 100,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.store,
                  size: 100,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'ShopSphere',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}