enum PaymentMethod {
  creditCard,
  debitCard,
  mobileBanking,
  cashOnDelivery,
  wallet,
}

enum PaymentStatus { pending, completed, failed, refunded }

class Payment {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final String? receiptUrl;
  final String? failureReason;

  Payment({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.method,
    this.status = PaymentStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.receiptUrl,
    this.failureReason,
  });

  Payment copyWith({
    PaymentStatus? status,
    DateTime? completedAt,
    String? transactionId,
    String? receiptUrl,
  }) {
    return Payment(
      id: id,
      orderId: orderId,
      userId: userId,
      amount: amount,
      method: method,
      status: status ?? this.status,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      transactionId: transactionId ?? this.transactionId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      failureReason: failureReason,
    );
  }
}
