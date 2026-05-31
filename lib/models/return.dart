enum ReturnStatus { pending, approved, shipped, received, completed, rejected }

class Return {
  final String id;
  final String orderId;
  final String userId;
  final String productId;
  final String productName;
  final String reason;
  final String? description;
  final ReturnStatus status;
  final double refundAmount;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final String? shippingLabel;
  final String? trackingId;

  Return({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.reason,
    this.description,
    this.status = ReturnStatus.pending,
    required this.refundAmount,
    required this.requestedAt,
    this.approvedAt,
    this.shippingLabel,
    this.trackingId,
  });

  Return copyWith({
    ReturnStatus? status,
    DateTime? approvedAt,
    String? shippingLabel,
    String? trackingId,
  }) {
    return Return(
      id: id,
      orderId: orderId,
      userId: userId,
      productId: productId,
      productName: productName,
      reason: reason,
      description: description,
      status: status ?? this.status,
      refundAmount: refundAmount,
      requestedAt: requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      shippingLabel: shippingLabel ?? this.shippingLabel,
      trackingId: trackingId ?? this.trackingId,
    );
  }
}
