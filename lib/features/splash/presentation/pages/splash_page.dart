import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/session/session_status.dart';
import '../../../../routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SessionManager _sessionManager = const SessionManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (RemoteConfigService.maintenanceMode) {
      return;
    }

    final result = await _sessionManager.checkSession();

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
    if (RemoteConfigService.maintenanceMode) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.build_circle_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Under Maintenance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  RemoteConfigService.promoBannerText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await RemoteConfigService.refresh();
                    if (!RemoteConfigService.maintenanceMode && mounted) {
                      await _initializeApp();
                    } else {
                      setState(() {});
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 128,
              height: 128,
              errorBuilder: (_, _, _) {
                return const Icon(Icons.store, size: 100);
              },
            ),
          ],
        ),
      ),
    );
  }
}
