import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firebase_service.dart';
import 'product_catalog_loader.dart';

/// Seeds the Firestore `products` collection from the bundled catalog.
class CatalogSeedingService {
  final FirebaseFirestore _firestore;

  CatalogSeedingService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.firestore;

  Future<CatalogSeedResult> seedProducts({bool overwrite = true}) async {
    final products = await ProductCatalogLoader.load();
    final batch = _firestore.batch();
    final collection = _firestore.collection('products');

    for (final product in products) {
      final docRef = collection.doc(product.id);
      if (overwrite) {
        batch.set(docRef, product.toFirestore());
      } else {
        batch.set(docRef, product.toFirestore(), SetOptions(merge: true));
      }
    }

    await batch.commit();

    return CatalogSeedResult(
      seededCount: products.length,
      productIds: products.map((p) => p.id).toList(growable: false),
    );
  }

  Future<int> getRemoteProductCount() async {
    final snapshot = await _firestore.collection('products').limit(1).get();
    if (snapshot.docs.isEmpty) return 0;

    final countSnapshot = await _firestore.collection('products').count().get();
    return countSnapshot.count ?? snapshot.docs.length;
  }
}

class CatalogSeedResult {
  final int seededCount;
  final List<String> productIds;

  const CatalogSeedResult({
    required this.seededCount,
    required this.productIds,
  });
}
