import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/firebase_bootstrap.dart';
import '../../core/services/messaging_service.dart';
import '../../features/notifications/domain/entities/app_notification.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';

/// Wires FCM foreground messages and pending notifications into Riverpod.
class FcmListener extends ConsumerStatefulWidget {
  final Widget child;

  const FcmListener({super.key, required this.child});

  @override
  ConsumerState<FcmListener> createState() => _FcmListenerState();
}

class _FcmListenerState extends ConsumerState<FcmListener> {
  @override
  void initState() {
    super.initState();

    MessagingService.onForegroundMessage = _handlePush;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseBootstrap.afterFirstFrame();
      await ref
          .read(notificationsControllerProvider.notifier)
          .ingestPendingMessages();
    });
  }

  void _handlePush(AppNotification notification) {
    ref
        .read(notificationsControllerProvider.notifier)
        .addPushNotification(notification);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
