import 'package:go_router/go_router.dart';
import '../features/authentication/presentation/pages/verify_email_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/authentication/presentation/pages/forgot_password_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
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
        path: RouteNames.verifyEmail,
        builder: (context, state) => const VerifyEmailPage(),
        ),

GoRoute(
  path: RouteNames.forgotPassword,
  builder: (context, state) => const ForgotPasswordPage(),
  ),
GoRoute(
  path: RouteNames.verifyEmail,
  builder: (context, state) =>
      const VerifyEmailPage(),
      ),
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => 
      const HomePage(),
    ),
  ],
);