import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthController(this.repository)
      : super(const AuthState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final AppUser user = await repository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final AppUser user = await repository.register(
        name: name,
        email: email,
        password: password,
      );

      await repository.sendEmailVerification();

      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await repository.logout();

    state = const AuthState();
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      await repository.forgotPassword(
        email: email,
      );

      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadCurrentUser() async {
    final user = await repository.getCurrentUser();

    state = state.copyWith(
      user: user,
    );
  }

  // --------------------------------------------------------
  // Email Verification
  // --------------------------------------------------------

  Future<bool> checkEmailVerification() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final verified =
          await repository.reloadAndCheckEmailVerification();

      state = state.copyWith(
        isLoading: false,
      );

      return verified;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );

      return false;
    }
  }

  Future<void> resendVerificationEmail() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      await repository.sendEmailVerification();

      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}