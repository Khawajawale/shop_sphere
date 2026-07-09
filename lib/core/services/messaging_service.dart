import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../features/notifications/domain/entities/app_notification.dart';
import 'fcm_background_handler.dart';
import 'firebase_service.dart';

typedef PushNotificationCallback = void Function(AppNotification notification);

/// Handles FCM permissions, token registration, and message routing.
class MessagingService {
  MessagingService._();

  static PushNotificationCallback? onForegroundMessage;

  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final settings = await FirebaseService.messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      debugPrint('FCM permission: ${settings.authorizationStatus}');
    }

    await _syncToken();

    FirebaseService.messaging.onTokenRefresh.listen((token) {
      _saveTokenToFirestore(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      final notification = _mapRemoteMessage(message);
      onForegroundMessage?.call(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final notification = _mapRemoteMessage(message);
      onForegroundMessage?.call(notification.copyWith(isRead: false));
    });

    final initialMessage = await FirebaseService.messaging.getInitialMessage();
    if (initialMessage != null) {
      onForegroundMessage?.call(_mapRemoteMessage(initialMessage));
    }
  }

  static Future<void> _syncToken() async {
    try {
      final token = await FirebaseService.messaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FCM token sync failed.');
      }
    }
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseService.auth.currentUser;
    if (user == null) return;

    try {
      await FirebaseService.firestore.collection('users').doc(user.uid).set(
        {
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Token will retry on next refresh
    }
  }

  static AppNotification _mapRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: message.messageId ??
          'fcm-${DateTime.now().millisecondsSinceEpoch}',
      title: message.notification?.title ?? 'ShopSphere',
      body: message.notification?.body ?? '',
      createdAt: DateTime.now(),
      type: message.data['type'] ?? 'push',
    );
  }

  static Future<void> syncTokenForCurrentUser() => _syncToken();
}
