import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static SharedPreferences? _preferences;

  // Initialize once when the app starts
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_preferences == null) {
      throw Exception(
        'AppPreferences not initialized. Call AppPreferences.init() first.',
      );
    }

    return _preferences!;
  }

  // ============================
  // Keys
  // ============================

  static const String onboardingCompletedKey =
      'onboarding_completed';

  // ============================
  // Onboarding
  // ============================

  static Future<void> setOnboardingCompleted(
    bool value,
  ) async {
    await instance.setBool(
      onboardingCompletedKey,
      value,
    );
  }

  static bool get onboardingCompleted {
    return instance.getBool(
          onboardingCompletedKey,
        ) ??
        false;
  }

  // ============================
  // Clear Everything
  // ============================

  static Future<void> clear() async {
    await instance.clear();
  }
}