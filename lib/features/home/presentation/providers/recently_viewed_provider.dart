import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/app_preferences.dart';
import '../../domain/entities/product.dart';
import 'product_provider.dart';

const _recentlyViewedKey = 'recently_viewed_product_ids';
const _maxRecentlyViewed = 10;

class RecentlyViewedController extends StateNotifier<List<String>> {
  final Ref ref;

  RecentlyViewedController(this.ref) : super([]) {
    _load();
  }

  void _load() {
    final prefs = AppPreferences.instance;
    state = prefs.getStringList(_recentlyViewedKey) ?? [];
  }

  Future<void> trackProduct(String productId) async {
    final updated = [
      productId,
      ...state.where((id) => id != productId),
    ].take(_maxRecentlyViewed).toList();

    state = updated;
    await AppPreferences.instance.setStringList(
      _recentlyViewedKey,
      updated,
    );
  }
}

final recentlyViewedControllerProvider =
    StateNotifierProvider<RecentlyViewedController, List<String>>((ref) {
  return RecentlyViewedController(ref);
});

final recentlyViewedProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(recentlyViewedControllerProvider);
  final allProducts = ref.watch(productControllerProvider).allProducts;

  if (ids.isEmpty || allProducts.isEmpty) return [];

  final productMap = {for (final p in allProducts) p.id: p};
  return ids
      .map((id) => productMap[id])
      .whereType<Product>()
      .toList(growable: false);
});
