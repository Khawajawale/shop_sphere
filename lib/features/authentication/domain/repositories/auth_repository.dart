import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> sendEmailVerification();

  Future<AppUser?> getCurrentUser();

  Stream<AppUser?> authStateChanges();

  Future<bool> reloadAndCheckEmailVerification();
  
  Future<void> reloadCurrentUser();
}