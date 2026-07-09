import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_sphere/core/storage/app_preferences.dart';
import 'package:shop_sphere/features/cart/presentation/providers/cart_provider.dart';
import 'package:shop_sphere/features/home/domain/entities/product.dart';
import 'package:shop_sphere/features/wishlist/presentation/providers/wishlist_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  final testProduct = Product(
    id: 'prod-001',
    name: 'Classic Leather Jacket',
    description: 'Timeless style leather jacket.',
    price: 120.0,
    salePrice: 100.0,
    images: const ['https://example.com/image.jpg'],
    categoryId: 'fashion',
    inStock: true,
    stockQuantity: 10,
    rating: 4.8,
    reviewCount: 42,
    featured: true,
    createdAt: DateTime.now(),
  );

  test('Wishlist toggles favorite product ids', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final wishlist = container.read(wishlistControllerProvider.notifier);
    expect(wishlist.isFavorite(testProduct.id), isFalse);

    wishlist.toggleFavorite(testProduct.id);
    expect(container.read(wishlistControllerProvider), contains(testProduct.id));

    wishlist.toggleFavorite(testProduct.id);
    expect(container.read(wishlistControllerProvider), isNot(contains(testProduct.id)));
  });

  test('Cart adds, updates quantity, and removes items', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final cart = container.read(cartControllerProvider.notifier);
    expect(container.read(cartControllerProvider), isEmpty);

    await cart.addItem(testProduct, quantity: 2, size: 'M', color: 'Black');
    expect(container.read(cartControllerProvider).first.quantity, 2);
    expect(container.read(cartTotalPriceProvider), 200.0);

    await cart.updateQuantity(testProduct, 5, size: 'M', color: 'Black');
    expect(container.read(cartTotalPriceProvider), 500.0);

    await cart.removeItem(testProduct, size: 'M', color: 'Black');
    expect(container.read(cartControllerProvider), isEmpty);
  });
}
