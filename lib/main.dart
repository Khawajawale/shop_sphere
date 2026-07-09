import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env_config.dart';
import 'core/services/app_version_service.dart';
import 'core/services/firebase_bootstrap.dart';
import 'core/services/release_monitoring_service.dart';
import 'core/storage/app_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/fcm_listener.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.load();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If Firebase app already exists, ignore the error!
    debugPrint('Firebase initializeApp error (probably duplicate app): $e');
  }

  try {
    await FirebaseBootstrap.initialize();
  } catch (e, stackTrace) {
    debugPrint('FirebaseBootstrap.initialize() error: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Always initialize these, regardless of Firebase errors!
  await AppPreferences.init();
  await AppVersionService.load();

  final prefs = AppPreferences.instance;
  final lastVersion = prefs.getString('last_app_version');
  if (lastVersion != null && lastVersion != AppVersionService.fullVersion) {
    try {
      await ReleaseMonitoringService.onAppUpdated(
        fromVersion: lastVersion,
        toVersion: AppVersionService.fullVersion,
      );
    } catch (_) {
      // Monitoring must never block app startup.
    }
  }
  await prefs.setString('last_app_version', AppVersionService.fullVersion);

  runApp(const ProviderScope(child: FcmListener(child: ShopSphere())));

  try {
    await ReleaseMonitoringService.onAppLaunched();
  } catch (_) {
    // Monitoring must never block first frame rendering.
  }
}

class ShopSphere extends StatelessWidget {
  const ShopSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ShopSphere',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
