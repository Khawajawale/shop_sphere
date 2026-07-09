import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/fcm_background_handler.dart';
import '../../../../core/services/firebase_bootstrap.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../domain/entities/app_notification.dart';

const _notificationsKey = 'app_notifications_json';

class NotificationsController extends StateNotifier<List<AppNotification>> {
  NotificationsController() : super([]) {
    _load();
  }

  void _load() {
    try {
      final raw = AppPreferences.instance.getString(_notificationsKey);
      if (raw == null) {
        state = _defaultNotifications();
        _save();
        return;
      }

      final decoded = json.decode(raw) as List<dynamic>;
      state = decoded
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = _defaultNotifications();
      _save();
    }
  }

  List<AppNotification> _defaultNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'notif-1',
        title: 'Welcome to ShopSphere',
        body: 'Explore curated premium products picked just for you.',
        createdAt: now.subtract(const Duration(hours: 2)),
        type: 'welcome',
      ),
      AppNotification(
        id: 'notif-2',
        title: 'Flash Sale Live',
        body: 'Up to 30% off on featured electronics. Limited time only.',
        createdAt: now.subtract(const Duration(days: 1)),
        type: 'promo',
      ),
      AppNotification(
        id: 'notif-3',
        title: 'Order Update',
        body: 'Your recent order is being prepared for shipment.',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
        type: 'order',
      ),
    ];
  }

  Future<void> _save() async {
    final encoded = json.encode(state.map((n) => n.toJson()).toList());
    await AppPreferences.instance.setString(_notificationsKey, encoded);
  }

  Future<void> addPushNotification(AppNotification notification) async {
    final exists = state.any((n) => n.id == notification.id);
    if (exists) return;

    state = [notification, ...state];
    await _save();
  }

  Future<void> ingestPendingMessages() async {
    final pending = await consumePendingFcmMessages();
    final bridge = PendingFcmBridge.instance.consume();

    for (final notification in [...pending, ...bridge]) {
      await addPushNotification(notification);
    }
  }

  Future<void> markAsRead(String id) async {
    state = state
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    await _save();
  }

  Future<void> markAllAsRead() async {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
    await _save();
  }

  Future<void> clearAll() async {
    state = [];
    await _save();
  }
}

final notificationsControllerProvider =
    StateNotifierProvider<NotificationsController, List<AppNotification>>((ref) {
  return NotificationsController();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsControllerProvider);
  return notifications.where((n) => !n.isRead).length;
});
