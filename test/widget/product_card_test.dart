import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/core/widgets/empty_state.dart';
import 'package:shop_sphere/features/home/domain/entities/product.dart';
import 'package:shop_sphere/features/home/presentation/widgets/product_card/product_card.dart';

void main() {
  final sampleProduct = Product(
    id: 'prod-test',
    name: 'Test Headphones',
    description: 'Premium wireless headphones.',
    price: 199.99,
    salePrice: 149.99,
    images: const [],
    categoryId: 'electronics',
    inStock: true,
    stockQuantity: 5,
    rating: 4.5,
    reviewCount: 10,
    featured: true,
    createdAt: DateTime(2026, 3, 1),
  );

  testWidgets('ProductCard displays name and supports semantics', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 260,
            height: 420,
            child: ProductCard(
              product: sampleProduct,
              onTap: () {},
              onAddToCart: () {},
              onWishlist: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Headphones'), findsOneWidget);
    expect(find.byType(ProductCard), findsOneWidget);

    final semantics = tester.getSemantics(find.byType(ProductCard));
    expect(semantics.label, contains('Test Headphones'));
  });

  testWidgets('EmptyState renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Cart Empty',
            subtitle: 'Add products to continue.',
          ),
        ),
      ),
    );

    expect(find.text('Cart Empty'), findsOneWidget);
    expect(find.text('Add products to continue.'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });
}
