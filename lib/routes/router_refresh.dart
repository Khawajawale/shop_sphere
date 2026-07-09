import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/services/firebase_service.dart';

/// Notifies [GoRouter] when Firebase auth state changes so redirects re-evaluate.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier() {
    _subscription = FirebaseService.auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerRefreshNotifier = RouterRefreshNotifier();
