import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../features/notifications/domain/entities/app_notification.dart';
import '../storage/app_preferences.dart';

const _pendingFcmKey = 'pending_fcm_notifications';

/// Top-level background handler required by Firebase Messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _persistBackgroundMessage(message);
}

Future<void> _persistBackgroundMessage(RemoteMessage message) async {
  await AppPreferences.init();

  final notification = AppNotification(
    id: message.messageId ??
        'fcm-${DateTime.now().millisecondsSinceEpoch}',
    title: message.notification?.title ?? 'ShopSphere',
    body: message.notification?.body ?? '',
    createdAt: DateTime.now(),
    type: message.data['type'] ?? 'push',
  );

  final prefs = AppPreferences.instance;
  final existing = prefs.getString(_pendingFcmKey);
  final List<dynamic> list =
      existing != null ? json.decode(existing) as List<dynamic> : [];

  list.insert(0, notification.toJson());
  await prefs.setString(_pendingFcmKey, json.encode(list));
}

/// Reads and clears pending FCM messages stored while app was terminated.
Future<List<AppNotification>> consumePendingFcmMessages() async {
  await AppPreferences.init();
  final prefs = AppPreferences.instance;
  final raw = prefs.getString(_pendingFcmKey);
  if (raw == null) return [];

  await prefs.remove(_pendingFcmKey);
  final decoded = json.decode(raw) as List<dynamic>;
  return decoded
      .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
      .toList();
}
