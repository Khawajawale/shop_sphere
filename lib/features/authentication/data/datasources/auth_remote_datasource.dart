import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firebase_service.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseService.auth;

  // -----------------------------
  // Sign In
  // -----------------------------
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } catch (_) {
      throw Exception(
        'Something went wrong. Please try again.',
      );
    }
  }

  // -----------------------------
  // Register
  // -----------------------------
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } catch (_) {
      throw Exception(
        'Something went wrong. Please try again.',
      );
    }
  }

  // -----------------------------
  // Logout
  // -----------------------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } catch (_) {
      throw Exception(
        'Unable to sign out. Please try again.',
      );
    }
  }

  // -----------------------------
  // Forgot Password
  // -----------------------------
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } catch (_) {
      throw Exception(
        'Unable to send password reset email.',
      );
    }
  }

  // -----------------------------
  // Send Email Verification
  // -----------------------------
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found.');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } catch (_) {
      throw Exception(
        'Unable to send verification email.',
      );
    }
  }

  // -----------------------------
  // Current User
  // -----------------------------
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // -----------------------------
  // Current User Stream
  // -----------------------------
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // -----------------------------
  // Firebase Error Mapper
  // -----------------------------
  String _mapFirebaseAuthException(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password should be at least 6 characters long.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      default:
        return e.message ??
            'Authentication failed. Please try again.';
    }
  }
}