class SellerStats {
  final double totalRevenue;
  final double pendingEarnings;
  final double totalEarnings;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final double avgOrderValue;
  final double commissionRate;
  final int totalProducts;
  final int approvedProducts;

  SellerStats({
    required this.totalRevenue,
    required this.pendingEarnings,
    required this.totalEarnings,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.avgOrderValue,
    required this.commissionRate,
    required this.totalProducts,
    required this.approvedProducts,
  });

  double get netEarnings =>
      totalEarnings - (totalEarnings * (commissionRate / 100));
}

class SellerPayout {
  final String id;
  final String sellerId;
  final double amount;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String status; // pending, approved, completed, failed
  final String bankAccount;
  final String? transactionId;

  SellerPayout({
    required this.id,
    required this.sellerId,
    required this.amount,
    required this.requestedAt,
    this.completedAt,
    this.status = 'pending',
    required this.bankAccount,
    this.transactionId,
  });
}
