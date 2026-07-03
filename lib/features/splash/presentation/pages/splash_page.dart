import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_sphere/core/constants/app_assets.dart';
import 'package:shop_sphere/core/services/firebase_service.dart';
import 'package:shop_sphere/routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Keep the splash screen visible for at least 3 seconds.
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final bool hasAccount = FirebaseService.auth.currentUser != null;

    if (hasAccount) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 100,
              height: 100,
              errorBuilder: (_, _, _) {
                return const Icon(Icons.store, size: 100);
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