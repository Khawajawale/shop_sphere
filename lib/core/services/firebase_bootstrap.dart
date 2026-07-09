import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../features/notifications/domain/entities/app_notification.dart';
import '../config/image_cache_config.dart';
import 'app_check_service.dart';
import 'fcm_background_handler.dart';
import 'messaging_service.dart';
import 'remote_config_service.dart';

/// Orchestrates all Firebase production services at app startup.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static Future<void> initialize() async {
    ImageCacheConfig.configure();
    try {
      await AppCheckService.initialize();
    } catch (e, stackTrace) {
      debugPrint('AppCheckService.initialize() error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
    try {
      await RemoteConfigService.initialize();
    } catch (e, stackTrace) {
      debugPrint('RemoteConfigService.initialize() error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } else {
      try {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      } catch (e, stackTrace) {
        debugPrint('FirebaseCrashlytics set enabled false error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    try {
      await MessagingService.initialize();
    } catch (e, stackTrace) {
      debugPrint('MessagingService.initialize() error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    // Enable Firestore offline persistence
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e, stackTrace) {
      debugPrint('FirebaseFirestore settings error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> afterFirstFrame() async {
    final pending = await consumePendingFcmMessages();
    if (pending.isNotEmpty) {
      PendingFcmBridge.instance.addAll(pending);
    }
  }
}

/// Lightweight bridge to pass pending FCM messages to Riverpod after startup.
class PendingFcmBridge {
  PendingFcmBridge._();

  static final PendingFcmBridge instance = PendingFcmBridge._();

  final List<AppNotification> _pending = [];

  void addAll(List<AppNotification> notifications) {
    _pending.addAll(notifications);
  }

  List<AppNotification> consume() {
    final copy = List<AppNotification>.from(_pending);
    _pending.clear();
    return copy;
  }
}
