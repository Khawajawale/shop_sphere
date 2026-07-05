import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';

class ProductRemoteDataSource {
  final CollectionReference<Map<String, dynamic>>
      _productsCollection =
      FirebaseService.firestore.collection('products');

  /// Fetch featured products
  Future<QuerySnapshot<Map<String, dynamic>>>
      getFeaturedProducts() {
    return _productsCollection
        .where('featured', isEqualTo: true)
        .get();
  }

  /// Fetch all products
  Future<QuerySnapshot<Map<String, dynamic>>>
      getAllProducts() {
    return _productsCollection.get();
  }

  /// Fetch products by category
  Future<QuerySnapshot<Map<String, dynamic>>>
      getProductsByCategory(
    String categoryId,
  ) {
    return _productsCollection
        .where('categoryId', isEqualTo: categoryId)
        .get();
  }

  /// Fetch one product
  Future<DocumentSnapshot<Map<String, dynamic>>>
      getProductById(
    String productId,
  ) {
    return _productsCollection
        .doc(productId)
        .get();
  }

  /// Search products
  ///
  /// Firestore doesn't support full-text search.
  /// For now we use prefix search.
  Future<QuerySnapshot<Map<String, dynamic>>>
      searchProducts(
    String query,
  ) {
    return _productsCollection
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();
  }
}