class Withdrawal {
  final String id;
  final String userId;
  final double amount;
  final String accountNumber;
  final String bankName;
  final String accountHolderName;
  final String status; // pending, approved, processing, completed, failed
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? rejectionReason;
  final String? transactionId;

  Withdrawal({
    required this.id,
    required this.userId,
    required this.amount,
    required this.accountNumber,
    required this.bankName,
    required this.accountHolderName,
    this.status = 'pending',
    required this.requestedAt,
    this.processedAt,
    this.rejectionReason,
    this.transactionId,
  });

  Withdrawal copyWith({
    String? status,
    DateTime? processedAt,
    String? rejectionReason,
    String? transactionId,
  }) {
    return Withdrawal(
      id: id,
      userId: userId,
      amount: amount,
      accountNumber: accountNumber,
      bankName: bankName,
      accountHolderName: accountHolderName,
      status: status ?? this.status,
      requestedAt: requestedAt,
      processedAt: processedAt ?? this.processedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
