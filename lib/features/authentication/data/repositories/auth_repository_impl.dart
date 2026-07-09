import 'package:shop_sphere/core/security/input_validators.dart';
import 'package:shop_sphere/core/services/firebase_service.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.register(
      email: email,
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

    await FirebaseService.firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set({
      ...user.toFirestore(),
      'role': 'customer',
    });

    return user;
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.login(
      email: email,
      password: password,
    );

    final snapshot = await FirebaseService.firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    return UserModel.fromFirestore(snapshot);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) {
    return remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> sendEmailVerification() {
    return remoteDataSource.sendEmailVerification();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = remoteDataSource.getCurrentUser();

    if (firebaseUser == null) return null;

    final snapshot = await FirebaseService.firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!snapshot.exists) return null;

    return UserModel.fromFirestore(snapshot);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return remoteDataSource.authStateChanges().asyncMap((_) async {
      return getCurrentUser();
    });
  }

  // --------------------------------------------------------
  // Email Verification
  // --------------------------------------------------------

  @override
  Future<void> reloadCurrentUser() async {
    final user = FirebaseService.auth.currentUser;

    if (user != null) {
      await user.reload();
    }
  }

  @override
  Future<bool> reloadAndCheckEmailVerification() async {
    await reloadCurrentUser();

    final user = FirebaseService.auth.currentUser;

    return user?.emailVerified ?? false;
  }

  @override
  Future<AppUser> updateProfile({
    required String name,
    String? phone,
  }) async {
    final nameError = InputValidators.validateName(name);
    if (nameError != null) {
      throw Exception(nameError);
    }
    final phoneError = InputValidators.validatePhone(phone);
    if (phoneError != null) {
      throw Exception(phoneError);
    }

    final firebaseUser = FirebaseService.auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('Not authenticated');
    }

    await firebaseUser.updateDisplayName(name);

    await FirebaseService.firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .update({
      'name': name,
      'phone': phone,
    });

    final snapshot = await FirebaseService.firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    return UserModel.fromFirestore(snapshot);
  }
}