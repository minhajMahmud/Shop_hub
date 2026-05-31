class Coupon {
  final String code;
  final String description;
  final int discountPercent;
  final double? maxDiscount;
  final double? minPurchase;
  final DateTime expiryDate;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  Coupon({
    required this.code,
    required this.description,
    required this.discountPercent,
    this.maxDiscount,
    this.minPurchase,
    required this.expiryDate,
    required this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExhausted => usedCount >= usageLimit;
  bool get isValid => isActive && !isExpired && !isExhausted;

  double calculateDiscount(double amount) {
    if (!isValid) return 0;
    double discount = (amount * discountPercent) / 100;
    if (maxDiscount != null) {
      discount = discount.clamp(0, maxDiscount!);
    }
    return discount;
  }
}
