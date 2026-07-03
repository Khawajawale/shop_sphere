import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Register a new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final firebaseUser = credential.user!;

    await firebaseUser.updateDisplayName(name);

    final user = UserModel(
      uid: firebaseUser.uid,
      name: name,
      email: email.trim(),
      phone: null,
      photoUrl: null,
      emailVerified: firebaseUser.emailVerified,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(user.toFirestore());

    return user;
  }

  // Login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final snapshot = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    return UserModel.fromFirestore(snapshot);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Current User
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) return null;

    final snapshot = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!snapshot.exists) return null;

    return UserModel.fromFirestore(snapshot);
  }

  // Auth State Changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}