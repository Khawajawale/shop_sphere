import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cart_controller.dart';
import '../../domain/entities/cart_item.dart';

final cartControllerProvider =
    StateNotifierProvider<CartController, List<CartItem>>((ref) {
  return CartController(ref);
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final cart = ref.watch(cartControllerProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartControllerProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});
