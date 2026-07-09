import 'package:flutter_test/flutter_test.dart';

import 'package:shop_sphere/features/catalog/data/product_catalog_loader.dart';
import 'package:shop_sphere/features/home/data/models/product_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Product catalog loader', () {
    setUp(() => ProductCatalogLoader.clearCache());

    test('loads 15 products from bundled JSON', () async {
      final products = await ProductCatalogLoader.load();

      expect(products, hasLength(15));
      expect(products.first, isA<ProductModel>());
      expect(products.where((p) => p.featured).length, greaterThan(5));
    });

    test('products have unique ids', () async {
      final products = await ProductCatalogLoader.load();
      final ids = products.map((p) => p.id).toSet();
      expect(ids.length, products.length);
    });
  });
}
