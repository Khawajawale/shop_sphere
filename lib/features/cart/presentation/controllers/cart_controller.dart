import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../domain/entities/cart_item.dart';

class CartController extends StateNotifier<List<CartItem>> {
  static const String _cartKey = 'cart_items_json';
  final Ref ref;

  CartController(this.ref) : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final prefs = AppPreferences.instance;
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        final productState = ref.read(productControllerProvider);
        final allProducts = productState.allProducts;

        final List<CartItem> items = [];
        for (final itemMap in decoded) {
          final prodId = itemMap['productId'];
          final productOpt = allProducts.where((p) => p.id == prodId);
          if (productOpt.isNotEmpty) {
            items.add(
              CartItem(
                product: productOpt.first,
                quantity: itemMap['quantity'] ?? 1,
                selectedSize: itemMap['selectedSize'],
                selectedColor: itemMap['selectedColor'],
              ),
            );
          }
        }
        state = items;
      }
    } catch (_) {
      // Fallback
    }
  }

  Future<void> _saveCart() async {
    final list = state.map((item) => {
      'productId': item.product.id,
      'quantity': item.quantity,
      'selectedSize': item.selectedSize,
      'selectedColor': item.selectedColor,
    }).toList();
    final prefs = AppPreferences.instance;
    await prefs.setString(_cartKey, json.encode(list));
  }

  Future<void> addItem(Product product, {int quantity = 1, String? size, String? color}) async {
    final existingIndex = state.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    final List<CartItem> updated = List.from(state);
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      updated[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      updated.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedSize: size,
          selectedColor: color,
        ),
      );
    }
    state = updated;
    await _saveCart();

    await AnalyticsService.logAddToCart(
      itemId: product.id,
      itemName: product.name,
      price: product.currentPrice,
      quantity: quantity,
    );
  }

  Future<void> updateQuantity(Product product, int newQuantity, {String? size, String? color}) async {
    if (newQuantity <= 0) {
      await removeItem(product, size: size, color: color);
      return;
    }

    final index = state.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (index >= 0) {
      final List<CartItem> updated = List.from(state);
      updated[index] = updated[index].copyWith(quantity: newQuantity);
      state = updated;
      await _saveCart();
    }
  }

  Future<void> removeItem(Product product, {String? size, String? color}) async {
    final List<CartItem> updated = List.from(state);
    updated.removeWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);
    state = updated;
    await _saveCart();
  }

  Future<void> clearCart() async {
    state = [];
    final prefs = AppPreferences.instance;
    await prefs.remove(_cartKey);
  }
}
