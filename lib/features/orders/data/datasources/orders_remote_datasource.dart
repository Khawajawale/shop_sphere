import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/order.dart';

class OrdersRemoteDataSource {
  final CollectionReference<Map<String, dynamic>> _ordersCollection =
      FirebaseService.firestore.collection('orders');

  Future<void> createOrder({
    required String userId,
    required OrderEntity order,
  }) async {
    await _ordersCollection.doc(order.id).set({
      'userId': userId,
      'totalAmount': order.totalAmount,
      'status': order.status,
      'createdAt': Timestamp.fromDate(order.createdAt),
      'shippingAddress': order.shippingAddress,
      if (order.paymentId != null) 'paymentId': order.paymentId,
      if (order.paymentStatus != null) 'paymentStatus': order.paymentStatus,
      if (order.cardLast4 != null) 'cardLast4': order.cardLast4,
      'items': order.items
          .map(
            (item) => {
              'productId': item.product.id,
              'quantity': item.quantity,
              'selectedSize': item.selectedSize,
              'selectedColor': item.selectedColor,
            },
          )
          .toList(),
    });
  }

  Future<List<Map<String, dynamic>>> getOrdersForUser(String userId) async {
    final snapshot = await _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
  }
}
