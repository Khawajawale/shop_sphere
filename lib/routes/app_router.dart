import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/services/firebase_service.dart';

import '../features/authentication/presentation/pages/verify_email_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/authentication/presentation/pages/forgot_password_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/main_navigation_page.dart';
import '../features/wishlist/presentation/pages/wishlist_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/orders/presentation/pages/order_history_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/checkout/presentation/pages/checkout_page.dart';
import '../features/products/presentation/pages/product_details_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/admin_product_management_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/profile_info_page.dart';
import '../core/security/input_validators.dart';
import 'route_names.dart';
import 'auth_redirect.dart';
import 'router_refresh.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  refreshListenable: routerRefreshNotifier,
  redirect: AuthRedirect.redirect,
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseService.analytics),
  ],
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.verifyEmail,
      builder: (context, state) => const VerifyEmailPage(),
    ),
    GoRoute(
      path: RouteNames.checkout,
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: RouteNames.search,
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouteNames.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: RouteNames.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: RouteNames.admin,
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: RouteNames.adminProducts,
      builder: (context, state) => const AdminProductManagementPage(),
    ),
    GoRoute(
      path: RouteNames.shippingAddresses,
      builder: (context, state) => const ProfileInfoPage(
        title: 'My Shipping Addresses',
        icon: Icons.location_on_outlined,
        description:
            'Manage your saved delivery locations here. Address editing can be connected to Firestore next.',
      ),
    ),
    GoRoute(
      path: RouteNames.paymentMethods,
      builder: (context, state) => const ProfileInfoPage(
        title: 'Saved Payment Methods',
        icon: Icons.payment_outlined,
        description:
            'Manage your saved payment methods here. Payment method storage can be connected securely in the next phase.',
      ),
    ),
    GoRoute(
      path: RouteNames.security,
      builder: (context, state) => const ProfileInfoPage(
        title: 'Security & Change Password',
        icon: Icons.security_outlined,
        description:
            'Use this area for password updates and account security settings.',
      ),
    ),
    GoRoute(
      path: RouteNames.faq,
      builder: (context, state) => const ProfileInfoPage(
        title: 'Frequently Asked Questions',
        icon: Icons.help_outline_rounded,
        description:
            'Common answers about ordering, payments, shipping, and returns will appear here.',
      ),
    ),
    GoRoute(
      path: RouteNames.support,
      builder: (context, state) => const ProfileInfoPage(
        title: 'Contact Support Services',
        icon: Icons.support_agent_outlined,
        description:
            'Reach support for order issues, account help, and app assistance from this screen.',
      ),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        if (InputValidators.validateProductId(id) != null) {
          return const Scaffold(
            body: Center(child: Text('Product not found.')),
          );
        }
        return ProductDetailsPage(productId: id);
      },
    ),

    // Nested persistent bottom navigation tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationPage(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Tab 2: Wishlist
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wishlist',
              builder: (context, state) => const WishlistPage(),
            ),
          ],
        ),
        // Tab 3: Cart
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),
        // Tab 4: Orders
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrderHistoryPage(),
            ),
          ],
        ),
        // Tab 5: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);