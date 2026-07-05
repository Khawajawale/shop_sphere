import '../services/firebase_service.dart';
import '../storage/app_preferences.dart';

import '../../features/authentication/data/models/user_model.dart';

import 'session_result.dart';
import 'session_status.dart';

class SessionManager {
  const SessionManager();

  Future<SessionResult> checkSession() async {
    // -------------------------
    // Onboarding
    // -------------------------

    if (!AppPreferences.onboardingCompleted) {
      return const SessionResult(
        status: SessionStatus.onboardingRequired,
      );
    }

    // -------------------------
    // Firebase Authentication
    // -------------------------

    final firebaseUser =
        FirebaseService.auth.currentUser;

    if (firebaseUser == null) {
      return const SessionResult(
        status: SessionStatus.unauthenticated,
      );
    }

    try {
      // Refresh user information
      await firebaseUser.reload();

      final refreshedUser =
          FirebaseService.auth.currentUser;

      if (refreshedUser == null) {
        await FirebaseService.auth.signOut();

        return const SessionResult(
          status: SessionStatus.unauthenticated,
        );
      }

      // -------------------------
      // Email Verification
      // -------------------------

      if (!refreshedUser.emailVerified) {
        return const SessionResult(
          status: SessionStatus.emailNotVerified,
        );
      }

      // -------------------------
      // Firestore User
      // -------------------------

      final snapshot = await FirebaseService.firestore
          .collection('users')
          .doc(refreshedUser.uid)
          .get();

      if (!snapshot.exists) {
        await FirebaseService.auth.signOut();

        return const SessionResult(
          status: SessionStatus.unauthenticated,
        );
      }

      final user =
          UserModel.fromFirestore(snapshot);

      return SessionResult(
        status: SessionStatus.authenticated,
        user: user,
      );
    } catch (_) {
      await FirebaseService.auth.signOut();

      return const SessionResult(
        status: SessionStatus.unauthenticated,
      );
    }
  }
}