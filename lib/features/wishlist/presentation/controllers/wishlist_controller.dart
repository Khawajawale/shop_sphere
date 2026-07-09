import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/app_preferences.dart';
import '../../../../features/home/domain/entities/product.dart';
import '../../../../features/home/presentation/providers/product_provider.dart';

class WishlistController extends StateNotifier<List<String>> {
  static const String _wishlistKey = 'wishlist_product_ids';
  final Ref ref;

  WishlistController(this.ref) : super([]) {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = AppPreferences.instance;
    final ids = prefs.getStringList(_wishlistKey) ?? [];
    state = ids;
  }

  Future<void> toggleFavorite(String productId) async {
    final updated = List<String>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;

    final prefs = AppPreferences.instance;
    await prefs.setStringList(_wishlistKey, updated);
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  List<Product> getFavoriteProducts() {
    final productState = ref.read(productControllerProvider);
    final allProducts = productState.allProducts;
    return allProducts.where((product) => state.contains(product.id)).toList();
  }
}
