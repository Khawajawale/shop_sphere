import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/wishlist_controller.dart';
import '../../../../features/home/domain/entities/product.dart';

final wishlistControllerProvider =
    StateNotifierProvider<WishlistController, List<String>>((ref) {
  return WishlistController(ref);
});

final favoriteProductsProvider = Provider<List<Product>>((ref) {
  ref.watch(wishlistControllerProvider);
  final controller = ref.read(wishlistControllerProvider.notifier);
  return controller.getFavoriteProducts();
});
