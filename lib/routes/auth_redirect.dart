import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/services/firebase_service.dart';
import '../features/authentication/presentation/providers/auth_state_provider.dart';
import 'route_names.dart';

/// Server-side auth is enforced by Firebase + Firestore rules.
/// Client redirects are a defense-in-depth layer only.
class AuthRedirect {
  static const _protectedPrefixes = [
    RouteNames.checkout,
    RouteNames.admin,
    RouteNames.editProfile,
    RouteNames.notifications,
    RouteNames.shippingAddresses,
    RouteNames.paymentMethods,
    RouteNames.security,
    RouteNames.faq,
    RouteNames.support,
    '/orders',
    '/cart',
    '/profile',
  ];

  static String? redirect(BuildContext context, GoRouterState state) {
    final container = ProviderScope.containerOf(context, listen: false);
    final providerUser = container.read(authControllerProvider).user;
    final firebaseUser = FirebaseService.auth.currentUser;
    final isLoggedIn = providerUser != null || firebaseUser != null;

    final path = state.matchedLocation;

    final isAuthRoute = path == RouteNames.login ||
        path == RouteNames.register ||
        path == RouteNames.forgotPassword ||
        path == RouteNames.splash ||
        path == RouteNames.onboarding ||
        path == RouteNames.verifyEmail;

    if (!isLoggedIn && _isProtected(path)) {
      return RouteNames.login;
    }

    if (isLoggedIn && isAuthRoute && path != RouteNames.splash) {
      return RouteNames.home;
    }

    return null;
  }

  static bool _isProtected(String path) {
    return _protectedPrefixes.any((p) => path.startsWith(p));
  }
}
