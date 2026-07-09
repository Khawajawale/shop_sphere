import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../data/datasources/orders_remote_datasource.dart';
import '../../data/utils/order_mapper.dart';
import '../../domain/entities/order.dart';

class OrdersController extends StateNotifier<List<OrderEntity>> {
  static const String _ordersKey = 'orders_history_json';
  final Ref ref;

  OrdersController(this.ref) : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final prefs = AppPreferences.instance;
      final ordersJson = prefs.getString(_ordersKey);
      if (ordersJson == null) return;

      final List<dynamic> decoded = json.decode(ordersJson);
      state = _mapOrders(decoded);
    } catch (_) {
      // Fallback to empty
    }
  }

  List<OrderEntity> _mapOrders(List<dynamic> decoded) {
    final allProducts = ref.read(productControllerProvider).allProducts;
    final List<OrderEntity> loaded = [];

    for (final orderMap in decoded) {
      final List<dynamic> itemsList = orderMap['items'] ?? [];
      final List<CartItem> cartItems = [];

      for (final itemMap in itemsList) {
        final prodId = itemMap['productId'];
        final productOpt = allProducts.where((p) => p.id == prodId);
        if (productOpt.isNotEmpty) {
          cartItems.add(
            CartItem(
              product: productOpt.first,
              quantity: itemMap['quantity'] ?? 1,
              selectedSize: itemMap['selectedSize'],
              selectedColor: itemMap['selectedColor'],
            ),
          );
        }
      }

      loaded.add(
        OrderEntity(
          id: orderMap['id'] ?? '',
          items: cartItems,
          totalAmount: (orderMap['totalAmount'] ?? 0.0).toDouble(),
          status: orderMap['status'] ?? 'Processing',
          createdAt: parseOrderDate(orderMap['createdAt']),
          shippingAddress: orderMap['shippingAddress'] ?? '',
          paymentId: orderMap['paymentId'] as String?,
          paymentStatus: orderMap['paymentStatus'] as String?,
          cardLast4: orderMap['cardLast4'] as String?,
        ),
      );
    }

    return loaded;
  }

  Future<void> _saveOrders() async {
    final list = state
        .map(
          (order) => {
            'id': order.id,
            'totalAmount': order.totalAmount,
            'status': order.status,
            'createdAt': order.createdAt.toIso8601String(),
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
          },
        )
        .toList();
    final prefs = AppPreferences.instance;
    await prefs.setString(_ordersKey, json.encode(list));
  }

  Future<void> syncFromRemote(String userId) async {
    try {
      final remote = ref.read(ordersRemoteDataSourceProvider);
      final remoteOrders = await remote.getOrdersForUser(userId);

      final normalized = remoteOrders.map(normalizeOrderMap).toList();
      final remoteMapped = _mapOrders(normalized);

      final merged = <String, OrderEntity>{
        for (final order in state) order.id: order,
        for (final order in remoteMapped) order.id: order,
      };

      state = merged.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      await _saveOrders();
    } catch (e) {
      await AnalyticsService.recordError(e, StackTrace.current);
    }
  }

  Future<void> placeOrder(
    List<CartItem> items,
    double total,
    String address, {
    String? orderId,
    String? paymentId,
    String? paymentStatus,
    String? cardLast4,
  }) async {
    final newOrder = OrderEntity(
      id: orderId ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      totalAmount: total,
      status: paymentStatus == 'succeeded' ? 'Confirmed' : 'Processing',
      createdAt: DateTime.now(),
      shippingAddress: address,
      paymentId: paymentId,
      paymentStatus: paymentStatus,
      cardLast4: cardLast4,
    );

    state = [newOrder, ...state];
    await _saveOrders();

    final user = ref.read(authControllerProvider).user;
    if (user != null) {
      try {
        await ref.read(ordersRemoteDataSourceProvider).createOrder(
              userId: user.uid,
              order: newOrder,
            );
      } catch (e) {
        await AnalyticsService.recordError(e, StackTrace.current);
      }
    }
  }
}

final ordersRemoteDataSourceProvider =
    Provider<OrdersRemoteDataSource>((ref) {
  return OrdersRemoteDataSource();
});

final ordersControllerProvider =
    StateNotifierProvider<OrdersController, List<OrderEntity>>((ref) {
  return OrdersController(ref);
});
