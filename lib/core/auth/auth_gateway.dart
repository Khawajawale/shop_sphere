import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_service.dart';

class AuthGateway {
  AuthGateway._();

  static final FirebaseAuth _auth = FirebaseService.auth;

  /// Returns the current Firebase user.
  static User? get currentUser => _auth.currentUser;

  /// Returns true if a user is signed in.
  static bool get isLoggedIn => currentUser != null;

  /// Returns true if the current user's email is verified.
  static bool get isEmailVerified =>
      currentUser?.emailVerified ?? false;

  /// Reloads the current user from Firebase.
  static Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  /// Refreshes the current user and returns the latest value.
  static Future<User?> refreshCurrentUser() async {
    await reloadUser();
    return _auth.currentUser;
  }

  /// Signs the current user out.
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}