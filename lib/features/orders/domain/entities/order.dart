import '../../../../features/cart/domain/entities/cart_item.dart';

class OrderEntity {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String shippingAddress;
  final String? paymentId;
  final String? paymentStatus;
  final String? cardLast4;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    this.paymentId,
    this.paymentStatus,
    this.cardLast4,
  });

  OrderEntity copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    String? status,
    DateTime? createdAt,
    String? shippingAddress,
    String? paymentId,
    String? paymentStatus,
    String? cardLast4,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cardLast4: cardLast4 ?? this.cardLast4,
    );
  }
}
