import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import 'auth_provider.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final AuthRepository repository =
        ref.read(authRepositoryProvider);

    return AuthController(repository);
  },
);