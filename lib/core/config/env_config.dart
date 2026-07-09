import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads configuration from `.env` (see `.env.example`).
/// Falls back to `--dart-define` values for CI builds without a committed `.env`.
class EnvConfig {
  EnvConfig._();

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // `.env` is optional when values are passed via --dart-define.
    }
    _loaded = true;
  }

  static String _require(String key) {
    final fromEnv = dotenv.maybeGet(key);
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;

    final fromDefine = String.fromEnvironment(key);
    if (fromDefine.isNotEmpty) return fromDefine;

    throw StateError(
      'Missing required configuration: $key. '
      'Copy .env.example to .env or pass --dart-define=$key=...',
    );
  }

  static String get firebaseAndroidApiKey =>
      _require('FIREBASE_ANDROID_API_KEY');

  static String get firebaseAndroidAppId =>
      _require('FIREBASE_ANDROID_APP_ID');

  static String get firebaseIosApiKey => _require('FIREBASE_IOS_API_KEY');

  static String get firebaseIosAppId => _require('FIREBASE_IOS_APP_ID');

  static String get firebaseMessagingSenderId =>
      _require('FIREBASE_MESSAGING_SENDER_ID');

  static String get firebaseProjectId => _require('FIREBASE_PROJECT_ID');

  static String get firebaseStorageBucket =>
      _require('FIREBASE_STORAGE_BUCKET');

  static String get firebaseIosBundleId =>
      _require('FIREBASE_IOS_BUNDLE_ID');

}
