import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/safe_error_message.dart';
import '../../data/catalog_seeding_service.dart';

final catalogSeedingServiceProvider = Provider<CatalogSeedingService>((ref) {
  return CatalogSeedingService();
});

final catalogSeedControllerProvider =
    StateNotifierProvider<CatalogSeedController, CatalogSeedState>((ref) {
  return CatalogSeedController(ref);
});

class CatalogSeedState {
  final bool isSeeding;
  final int? remoteCount;
  final String? message;
  final String? error;

  const CatalogSeedState({
    this.isSeeding = false,
    this.remoteCount,
    this.message,
    this.error,
  });

  CatalogSeedState copyWith({
    bool? isSeeding,
    int? remoteCount,
    String? message,
    String? error,
  }) {
    return CatalogSeedState(
      isSeeding: isSeeding ?? this.isSeeding,
      remoteCount: remoteCount ?? this.remoteCount,
      message: message,
      error: error,
    );
  }
}

class CatalogSeedController extends StateNotifier<CatalogSeedState> {
  final Ref ref;

  CatalogSeedController(this.ref) : super(const CatalogSeedState());

  Future<void> refreshRemoteCount() async {
    try {
      final count =
          await ref.read(catalogSeedingServiceProvider).getRemoteProductCount();
      state = state.copyWith(remoteCount: count, error: null);
    } catch (e) {
      state = state.copyWith(error: SafeErrorMessage.catalogSeedFailed);
    }
  }

  Future<bool> seedCatalog() async {
    state = state.copyWith(isSeeding: true, message: null, error: null);

    try {
      final result =
          await ref.read(catalogSeedingServiceProvider).seedProducts();
      state = state.copyWith(
        isSeeding: false,
        remoteCount: result.seededCount,
        message: 'Seeded ${result.seededCount} products to Firestore.',
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSeeding: false,
        error: SafeErrorMessage.catalogSeedFailed,
      );
      return false;
    }
  }
}
