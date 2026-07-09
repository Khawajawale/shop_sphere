import 'package:flutter/foundation.dart';

import 'analytics_service.dart';
import 'remote_config_service.dart';

/// Tracks production health signals after app launch and key lifecycle events.
class ReleaseMonitoringService {
  ReleaseMonitoringService._();

  static bool _sessionStarted = false;

  /// Call once after Firebase and Remote Config are initialized.
  static Future<void> onAppLaunched() async {
    if (_sessionStarted) return;
    _sessionStarted = true;

    await AnalyticsService.logCustomEvent(
      'ss_app_launch',
      parameters: {
        'build_mode': kReleaseMode
            ? 'release'
            : kProfileMode
                ? 'profile'
                : 'debug',
        'maintenance_mode': RemoteConfigService.maintenanceMode ? 1 : 0,
        'flash_sale_enabled': RemoteConfigService.flashSaleEnabled ? 1 : 0,
      },
    );

    await AnalyticsService.logCustomEvent('ss_session_started');
  }

  /// Call when user completes first meaningful screen (e.g. home).
  static Future<void> onSessionReady({required String entryPoint}) async {
    await AnalyticsService.logCustomEvent(
      'ss_session_ready',
      parameters: {'entry_point': entryPoint},
    );
  }

  /// Call after a successful store release build is installed (optional deep link).
  static Future<void> onAppUpdated({
    required String fromVersion,
    required String toVersion,
  }) async {
    await AnalyticsService.logCustomEvent(
      'ss_app_updated',
      parameters: {
        'from_version': fromVersion,
        'to_version': toVersion,
      },
    );
  }
}
