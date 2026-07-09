import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Remote configuration keys used across ShopSphere.
class RemoteConfigKeys {
  RemoteConfigKeys._();

  static const flashSaleEnabled = 'flash_sale_enabled';
  static const freeShippingThreshold = 'free_shipping_threshold';
  static const maintenanceMode = 'maintenance_mode';
  static const minAppVersion = 'min_app_version';
  static const promoBannerText = 'promo_banner_text';
}

/// Fetches and exposes Firebase Remote Config values.
class RemoteConfigService {
  RemoteConfigService._();

  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      RemoteConfigKeys.flashSaleEnabled: true,
      RemoteConfigKeys.freeShippingThreshold: 50.0,
      RemoteConfigKeys.maintenanceMode: false,
      RemoteConfigKeys.minAppVersion: '1.0.0',
      RemoteConfigKeys.promoBannerText: 'Free shipping on orders over \$50',
    });

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Use defaults when fetch fails (offline, etc.)
    }

    _initialized = true;
  }

  static bool get flashSaleEnabled =>
      _remoteConfig.getBool(RemoteConfigKeys.flashSaleEnabled);

  static double get freeShippingThreshold =>
      _remoteConfig.getDouble(RemoteConfigKeys.freeShippingThreshold);

  static bool get maintenanceMode =>
      _remoteConfig.getBool(RemoteConfigKeys.maintenanceMode);

  static String get minAppVersion =>
      _remoteConfig.getString(RemoteConfigKeys.minAppVersion);

  static String get promoBannerText =>
      _remoteConfig.getString(RemoteConfigKeys.promoBannerText);

  static Future<void> refresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Keep cached values
    }
  }
}
