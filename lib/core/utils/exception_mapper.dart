import 'package:firebase_auth/firebase_auth.dart';

import '../errors/auth_exception.dart';

class ExceptionMapper {
  static AuthException mapFirebaseAuthException(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException(
          'No account found with this email.',
        );

      case 'wrong-password':
        return const AuthException(
          'Incorrect password.',
        );

      case 'email-already-in-use':
        return const AuthException(
          'This email is already registered.',
        );

      case 'invalid-email':
        return const AuthException(
          'Please enter a valid email address.',
        );

      case 'weak-password':
        return const AuthException(
          'Password is too weak.',
        );

      case 'network-request-failed':
        return const AuthException(
          'Please check your internet connection.',
        );

      case 'too-many-requests':
        return const AuthException(
          'Too many attempts. Please try again later.',
        );

      default:
        return AuthException(
          e.message ?? 'Authentication failed.',
        );
    }
  }
}