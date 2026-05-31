enum OrderStatus { pending, confirmed, shipped, delivered, cancelled, returned }

class Order {
  final String id;
  final String userId;
  final String? sellerId;
  final List<OrderItem> items;
  final double totalPrice;
  final double discount;
  final double shippingCost;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String? trackingId;
  final String? couponCode;
  final String? address;
  final String? paymentMethod;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    this.sellerId,
    required this.items,
    required this.totalPrice,
    required this.discount,
    this.shippingCost = 0,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.estimatedDelivery,
    this.trackingId,
    this.couponCode,
    this.address,
    this.paymentMethod,
    this.notes,
  });

  double get finalTotal => totalPrice - discount + shippingCost;

  Order copyWith({
    OrderStatus? status,
    DateTime? estimatedDelivery,
    String? trackingId,
    String? paymentMethod,
    String? notes,
  }) {
    return Order(
      id: id,
      userId: userId,
      sellerId: sellerId,
      items: items,
      totalPrice: totalPrice,
      discount: discount,
      shippingCost: shippingCost,
      status: status ?? this.status,
      createdAt: createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingId: trackingId ?? this.trackingId,
      couponCode: couponCode,
      address: address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
