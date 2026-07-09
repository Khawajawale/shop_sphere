import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_service.dart' as app_firebase;

/// Centralized analytics and crash reporting for ShopSphere.
class AnalyticsService {
  AnalyticsService._();

  static bool get _isAvailable => Firebase.apps.isNotEmpty;

  static FirebaseAnalytics get _analytics => app_firebase.FirebaseService.analytics;

  static Future<void> setUserId(String? userId) async {
    if (!_isAvailable) return;
    await _analytics.setUserId(id: userId);
    if (userId != null) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  static Future<void> logLogin({required String method}) async {
    if (!_isAvailable) return;
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp({required String method}) async {
    if (!_isAvailable) return;
    await _analytics.logSignUp(signUpMethod: method);
  }

  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isAvailable) return;
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  static Future<void> logViewItem({
    required String itemId,
    required String itemName,
    String? category,
    double? price,
  }) async {
    if (!_isAvailable) return;
    await _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: category,
          price: price,
        ),
      ],
    );
  }

  static Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
    int quantity = 1,
  }) async {
    if (!_isAvailable) return;
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          price: price,
          quantity: quantity,
        ),
      ],
      value: price * quantity,
      currency: 'USD',
    );
  }

  static Future<void> logSearch({required String searchTerm}) async {
    if (!_isAvailable) return;
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  static Future<void> logPurchase({
    required String transactionId,
    required double value,
    required int itemCount,
  }) async {
    if (!_isAvailable) return;
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: 'USD',
      items: List.generate(
        itemCount,
        (_) => AnalyticsEventItem(itemName: 'order_item'),
      ),
    );
  }

  static Future<void> logCustomEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (!_isAvailable) return;
    await _analytics.logEvent(
      name: name,
      parameters: _sanitizeParameters(parameters),
    );
  }

  static Map<String, Object>? _sanitizeParameters(Map<String, Object>? input) {
    if (input == null) return null;

    final Map<String, Object> out = <String, Object>{};
    input.forEach((key, value) {
      // Firebase Analytics requires values to be String or num.
      // Convert common app-level types safely to avoid runtime assertions.
      if (value is String || value is num) {
        out[key] = value;
        return;
      }
      if (value is bool) {
        out[key] = value ? 1 : 0;
        return;
      }
      if (value is DateTime) {
        out[key] = value.toIso8601String();
        return;
      }

      out[key] = value.toString();
    });

    return out.isEmpty ? null : out;
  }

  static Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    if (!_isAvailable) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: fatal,
    );
  }
}
